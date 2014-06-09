package com.site.app
{

import com.davidcaneso.display.drawing.SquareArea;
import com.davidcaneso.singletons.StageReference;
import com.davidcaneso.utils.LiveTrace;
import com.site.AppUser;

import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
import flash.media.Video;
import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.URLVariables;

    import com.adobe.serialization.json.JSON

import flash.utils.ByteArray;

import ru.inspirit.net.MultipartURLLoader;

public class VideoFileUploader extends EventDispatcher
    {
        //development properties
        public var showTraces:Boolean = true;
        private var _className:String = 'VideoFileUploader';

        //properties
        private var _dev:Boolean;
        private var _devFile:String;
        private var _uploadScript:String;
        private var _fileReference:FileReference;
        private var _fileLoader:MultipartURLLoader;

        public var fileFilter:FileFilter;
        public const fileSizeMax:int = int((1024 * 1000) * 10);



        //contstructor
        public function VideoFileUploader(uploadScript:String, devMode:Boolean=false,devFile:String='devFilePath'):void
        {
            _uploadScript = uploadScript;

            _classTrace('_uploadScript '+_uploadScript);

            _dev = devMode;
            _devFile = devFile;
            fileFilter = new FileFilter("Choose A Video","*.mov;*.mp4;*.flv;*.f4v");

            _fileReference = new FileReference();
            _fileReference.addEventListener(Event.OPEN,_handleFileReferenceEvent);
            _fileReference.addEventListener(Event.SELECT,_handleFileReferenceEvent);
            _fileReference.addEventListener(Event.CANCEL,_handleFileReferenceEvent);
            _fileReference.addEventListener(IOErrorEvent.IO_ERROR,_handleFileReferenceEvent);
            _fileReference.addEventListener(ProgressEvent.PROGRESS,_handleFileReferenceEvent);
            _fileReference.addEventListener(Event.COMPLETE,_handleFileReferenceEvent);
            _fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,_handleFileReferenceEvent);

            _fileLoader = new MultipartURLLoader();
            _fileLoader.addEventListener(Event.COMPLETE, _onUploadVideoComplete);
        }

        public function browseForFile():void
        {
            _fileReference.browse([fileFilter]);
            dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.BROWSE_START,'',0));
        }

        public function get fileReference():FileReference
        {
            return _fileReference;
        }

//        public function uploadVideoRecording(data:ByteArray, fileName:String):void
//        {
//
//            _classTrace('let the user know the upload has started');
//            _fileLoader.clearFiles();
//            _fileLoader.clearVariables();
//
//            _fileLoader.addVariable("origin", 'upload');
//            _fileLoader.addFile(data, fileName, "video");
//            _fileLoader.load(_uploadScript);
//
//            trace('let the user know the upload has started');
//        }




        //private function
        private function _handleFileReferenceEvent(e:Event):void
        {
            switch (e.type)
            {
                case Event.OPEN :
                    _classTrace(('fileOpenHandler ' + e.toString()));
                    dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.START,'',0));
                    break;

                case Event.CANCEL :
                    _classTrace(('Event.CANCEL ' + e.toString()));
                    dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.BROWSE_CANCEL,'',0));
                    break;

                case Event.SELECT :
                    _classTrace(('Event.SELECT ' + e.toString()));
                    _fileReference = FileReference(e.target);
                    _classTrace(e.target.toString());
                    dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.BROWSE_CANCEL,'',0));

    //                var date:Date = new Date  ;
    //                var prefix:String = String(date.getTime());
    //                var params:URLVariables = new URLVariables  ;
    //                params.file = prefix;
    //                var uploadURL:URLRequest = new URLRequest  ;
    //                uploadURL.url = String(_uploadScript);
    //                uploadURL.method = URLRequestMethod.POST;
    //                uploadURL.data = params;

                    if (_dev)
                    {
                        _classTrace('_dev mode load dummy asset');
                        AppUser.userVideoPath = _devFile;
                        dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.COMPLETE,_devFile,100));
                    }
                    else
                    {
                        _classTrace('check file size '+_fileReference.size+' < '+fileSizeMax);
                        //dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.SELECT,_fileReference.name,100));
                        //_fileReference.upload(uploadURL);
                        if (_fileReference.size < fileSizeMax)
                        {
                            _classTrace('file is correct size proceed to load');
                            //_fileReference.addEventListener(Event.COMPLETE, loadFile, false, 0, true);
                            _fileReference.load();
                        }
                        else
                        {
                            // refuse file
                            rejectFile();
                        }
                    }
                    break;

                case IOErrorEvent.IO_ERROR :
                    _classTrace(("ioErrorHandler: " + IOErrorEvent(e)));
                    dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.ERROR,'',0));
                    break;

                case ProgressEvent.PROGRESS :
                    var file:FileReference = FileReference(e.target);
                    _classTrace(((((("progressHandler: name=" + file.name) + " bytesLoaded=") + ProgressEvent(e).bytesLoaded) + " bytesTotal=") + ProgressEvent(e).bytesTotal));
                    var percent:int = int((ProgressEvent(e).bytesLoaded / ProgressEvent(e).bytesTotal) * 100);
                    dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.UPDATE,file.name,percent));
                    break;

                case Event.COMPLETE :
                    _classTrace(('Event.COMPLETE ' + e.toString()));
                    _classTrace('load file');
                    loadFile();
                    break;

                case DataEvent.UPLOAD_COMPLETE_DATA :
                    _classTrace(("dataCompleteHandler: " + FileReference(DataEvent(e).target).name));

                    var returned:Object = DataEvent(e)['data'];
                    _classTrace(('returned = ' + returned));

                    var returnedString:URLVariables = new URLVariables(returned.toString());
                    _classTrace(('success  =' + returnedString.success));
                    if (returnedString.success)
                    {
                        dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.COMPLETE,returnedString.path,100));
                    }
                    else
                    {
                        _classTrace(('error: ' + returned.reason));
                        dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.ERROR,returned.reason,0));
                    }
                    break;
            }
        }

        private function loadFile():void
        {

            _classTrace('let the user know the upload has started');
            _fileLoader.clearFiles();
            _fileLoader.clearVariables();

            _fileLoader.addVariable("origin", 'upload');
            _fileLoader.addFile(_fileReference.data, _fileReference.name, "video");
            _fileLoader.load(_uploadScript);

            trace('let the user know the upload has started');
            //serverHandler.addEventListener(ExpendableEvents.VIDEO_SAVED, videoSaved, false, 0, true);
            //serverHandler.uploadVideo(file.data, file.name);
        }


        private function rejectFile():void
        {
            trace("file too big");
            var notice:AppNotificationEvent = new AppNotificationEvent(AppNotificationEvent.SHOW_NOTIFICATION);
                notice.notificationType = AppNotificationEvent.VIDEO_FILE_TOO_LARGE;
             StageReference.instance.stage.dispatchEvent(notice);
        }



        private function _onUploadVideoComplete(e:Event):void
        {
            var fileLoaderData:String = _fileLoader.loader.data;
            _classTrace('fileLoaderData '+fileLoaderData);

            var status:String = com.adobe.serialization.json.JSON.decode(fileLoaderData).status;
            _classTrace("status returned as " + status);

            if (status == "success")
            {
                // now get succeeded object
                var dataObject:Object = com.adobe.serialization.json.JSON.decode(fileLoaderData).data;
                var succeededObj:Object = dataObject.succeeded;
                var videoString:String = succeededObj.video;
                _classTrace("video path is " + videoString);
                AppUser.userVideoPath = videoString;
                dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.COMPLETE, videoString, 100));
            }
            else
            {
                _classTrace("video upload failed");
                dispatchEvent(new VideoFileUploaderEvent(VideoFileUploaderEvent.ERROR,'',0));
            }


        }



        private function _classTrace(val: * ):void
        {
            if (showTraces)
            {
                LiveTrace.output(((_className + ': ') + val));
            }
        }

    }

}