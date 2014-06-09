/**
 * Created by ifreelance3 on 5/15/14.
 */
package com.site
{

    import com.adobe.serialization.json.JSON;
    import com.davidcaneso.events.loading.PreloaderEvent;
    import com.davidcaneso.events.loading.ServerLoaderEvent;
    import com.davidcaneso.loading.Preloader;
    import com.davidcaneso.loading.ServerLoader;
    import com.davidcaneso.singletons.StageReference;
import com.davidcaneso.utils.LiveTrace;
import com.greensock.TweenMax;
import com.greensock.easing.Quad;
import com.site.app.AppConsts;

    import flash.display.MovieClip;
    import flash.net.URLVariables;

    [SWF(backgroundColor=0x000000, frameRate=30, width=470, height=345)]
    public class SharePlayerShell extends MovieClip
    {
        public var mainUrl:String = 'https://bpginteractive.com/dev/getonup/';
        public var mainDbUrl:String = 'http://handheldpress.net/';

        private var dbId:String;
        private var videoDeeplink:String;


        private var devUrl:String = '../../';

        private var sharePlayerVisualsUrl:String = 'assets/flash/sharePlayer102.swf';

        private var databaseLoader:ServerLoader;
        private var preloader:Preloader;
        private var _container:MovieClip;
        private var _stageContent:MovieClip;
        //private var _devData:String = '{"status":"success","data":{"id":"104","timestamp":"2014-05-14 17:48:01","name":"sit dance","base_path":"","image_path":"4702111234273657200.png","gif_path":"4702111234273657200.gif","video_path":"4702111234273657200","origin":"webcam","status":"approved"}}';
        private var _devData:String = '{"status":"success","data":{"id":"99","timestamp":"2014-05-13 18:32:45","name":"costumed","base_path":"","image_path":"550fcf6359b0c0eb84ec71c237df709amov.png","gif_path":"550fcf6359b0c0eb84ec71c237df709amov.gif","video_path":"550fcf6359b0c0eb84ec71c237df709a.mov","origin":"","status":"approved"}}';


        private var _defaultDbId:String = '26';

        public function SharePlayerShell()
        {
            mainUrl = 'https://www.cantstopthefunk.com/';
            mainDbUrl = mainUrl;

            StageReference.instance.stage = this.stage;

            _container = new MovieClip();
            addChild(_container);

            _stageContent = new sharePlayerShellStageContent();

            sharePlayerShellStageContent(_stageContent).loaderVisual.masking.cacheAsBitmap = true;
            sharePlayerShellStageContent(_stageContent).loaderVisual.fill.cacheAsBitmap = true;
            sharePlayerShellStageContent(_stageContent).loaderVisual.fill.mask = sharePlayerShellStageContent(_stageContent).loaderVisual.masking;

            addChild(_stageContent);



            var lt:LiveTrace = LiveTrace.instance;
                lt.x = 250;
                LiveTrace.changeSize(200, 320);
            //addChild(lt);

            if(MovieClip(this).loaderInfo.parameters.id)
            {
                dbId = MovieClip(this).loaderInfo.parameters.id;
            }

            if(MovieClip(this).loaderInfo.parameters.v)
            {
                videoDeeplink = MovieClip(this).loaderInfo.parameters.v;
            }

            databaseLoader = new ServerLoader(false, false);
            databaseLoader.devLoadedData = _devData;
            databaseLoader.addEventListener(ServerLoaderEvent.START, _handleServerLoaderEvent);
            databaseLoader.addEventListener(ServerLoaderEvent.ERROR, _handleServerLoaderEvent);
            databaseLoader.addEventListener(ServerLoaderEvent.COMPLETE, _handleServerLoaderEvent);

            preloader = new Preloader();
            preloader.addEventListener(PreloaderEvent.START, _handlePreloaderEvent);
            preloader.addEventListener(PreloaderEvent.COMPLETE, _handlePreloaderEvent);
            preloader.addEventListener(PreloaderEvent.ERROR, _handlePreloaderEvent);
            preloader.addEventListener(PreloaderEvent.UPDATE, _handlePreloaderEvent);


            var sharePlayerUrl:String = mainUrl + sharePlayerVisualsUrl;
            if(loaderInfo.url.substr(0, 7) == 'file://' || loaderInfo.url.indexOf('localhost') >= 0 )
            {
                sharePlayerUrl = devUrl + sharePlayerVisualsUrl;
            }

            LiveTrace.output('sharePlayerUrl: '+sharePlayerUrl);
            LiveTrace.output('dbId: '+dbId);
            LiveTrace.output('wide: '+StageReference.instance.stage.stageWidth);
            LiveTrace.output('hi: '+StageReference.instance.stage.stageHeight);

            preloader.addToLoadStack( sharePlayerUrl, _container);
            preloader.startLoad();
        }

        private function _handlePreloaderEvent(e:PreloaderEvent):void
        {
            switch(e.type)
            {
                case PreloaderEvent.START:

                    break;

                case PreloaderEvent.UPDATE:
                    sharePlayerShellStageContent(_stageContent).loaderVisual.gotoAndStop(e.percent);
                    updateLoaderText(e.percent + '%');
                    break;

                case PreloaderEvent.COMPLETE:

                    updateLoaderText('connecting...');

                        if(!dbId)
                            dbId = _defaultDbId;
                        else if(dbId.length == 0 || dbId == "undefined")
                        {
                            dbId = _defaultDbId;
                        }

                    var params:URLVariables = new URLVariables();
                        params.id = dbId;

                    databaseLoader.startLoad(mainDbUrl + AppConsts.getByIdPath(), params, 'text', true);
                    break;

                case PreloaderEvent.ERROR:
                    break;
            }
        }

        private function _handleServerLoaderEvent(e:ServerLoaderEvent):void
        {
            switch(e.type)
            {
                case ServerLoaderEvent.START:
                    updateLoaderText('connecting...');
                    break;

                case ServerLoaderEvent.COMPLETE:


                    var jsonData:Object = com.adobe.serialization.json.JSON.decode(e.loadedData);
                    if(jsonData.status == 'success')
                    {
                        LiveTrace.output('loadedData '+ e.loadedData);
                        SharePlayer(_container.getChildAt(0)).setup(e.loadedData, mainUrl);
                        _animatePreloaderOut();
                    }
                    else
                    {
                        updateLoaderText('sorry that video was not found');
                    }
                    break;

                case ServerLoaderEvent.ERROR:
                    updateLoaderText('sorry that video was not found');
                    break;
            }
        }

        private function updateLoaderText(val:String):void
        {
            sharePlayerShellStageContent(_stageContent).loaderVisual.pctField.text = val.toUpperCase();
        }

        private function _animatePreloaderOut():void
        {
            //updateLoaderText('here we go');
            TweenMax.to(sharePlayerShellStageContent(_stageContent),.3, {autoAlpha:0, ease:Quad.easeOut});
        }


    }
}
