﻿package com.site.ui{	import flash.display.*;	import flash.text.*;	import flash.events.*;	import flash.geom.Point;		import com.greensock.*	import com.greensock.easing.*		import com.davidcaneso.framework.Section;	import com.davidcaneso.framework.DevelopmentEnvironment	import com.davidcaneso.singletons.RuntimeAssets	import com.davidcaneso.singletons.Styling	import com.davidcaneso.singletons.XMLData	import com.davidcaneso.events.framework.DevelopmentEnvironmentEvent	import com.davidcaneso.events.framework.SiteManagerEvent;	import com.davidcaneso.events.framework.SectionEvent;	import com.davidcaneso.text.DynamicTextField;	import com.davidcaneso.framework.SimpleLink;	import com.davidcaneso.display.drawing.SquareArea;	import com.davidcaneso.display.buttons.BasicButton	import com.davidcaneso.display.buttons.LinkButton		import com.davidcaneso.loading.Preloader;	import com.site.sections.ProjectData;	import com.site.ui.ThumbLiveLinkButton		import com.davidcaneso.events.loading.PreloaderEvent;	import com.site.ui.events.ProjectThumbEvent;	import com.davidcaneso.display.drawing.SquareOutline;	import com.davidcaneso.display.layout.Alignment;	public class ProjectThumb extends Sprite	{		private var _projectData:ProjectData		private var _container:Sprite		private var _imageLoader:ThumbLoader		private var _imageLoaderVisual:DynamicTextField		private var _imageMask:SquareArea				private var _rollOverOutline:SquareOutline		private var _rollOverMask:SquareArea				private var _title:DynamicTextField		private var _imageHolder:Sprite		private var _liveLink:ThumbLiveLinkButton		private var _button:BlankButton		private var _outlineWidth:int = 10		private var _outlineHeight:int = 10		private var _noProject:Boolean				public function ProjectThumb(projectData:ProjectData)		{			//super(href);						_projectData = projectData;			if(_projectData.imageList.length == 1 && _projectData.imageList[0] == '') _noProject = true;									var _area = new SquareArea(130, 150)			_area.alpha = .2			_area.visible = false						_imageMask = new SquareArea(120, 76)			_imageMask.x = 5			_imageMask.y = 5			_imageHolder = new Sprite()			_imageHolder.alpha = 0			_imageHolder.mask = _imageMask						_imageLoader = new ThumbLoader(_imageHolder)			_imageLoader.addEventListener(PreloaderEvent.COMPLETE, _fitImage)			_imageLoader.addEventListener(PreloaderEvent.UPDATE, _updateLoader)						_imageLoaderVisual = new DynamicTextField(_imageMask.width, 0, 'thumbLoader', TextFieldAutoSize.LEFT)			_imageLoaderVisual.text = 'LOADING 0%';			_imageLoaderVisual.x = _imageMask.x			_imageLoaderVisual.y = int((_imageMask.height - _imageLoaderVisual.height) * .5) + 3						_rollOverMask = new SquareArea(_imageMask.width, _imageMask.height)			_rollOverMask.x = _imageMask.x			_rollOverMask.y = _imageMask.y			_rollOverMask.visible = false			_rollOverOutline = new SquareOutline(_imageMask.width, _imageMask.height, _outlineWidth, _outlineHeight, _projectData.color, 0, true)			_rollOverOutline.knockout()			_rollOverOutline.mask = _rollOverMask			_rollOverOutline.x = int(_imageMask.x + int(_imageMask.width * .5))			_rollOverOutline.y = int(_imageMask.y + int(_imageMask.height * .5))			_rollOverOutline.scaleX = _rollOverOutline.scaleY = 1.2						_title = new DynamicTextField(_area.width, 0, 'thumbTitle', TextFieldAutoSize.LEFT)			_title.styleSheet = Styling.instance.cssStyleSheet			if(_noProject)	_title.y = _imageMask.y			else			_title.y = _imageMask.height + 12			_title.htmlText = _projectData.title						_liveLink = new ThumbLiveLinkButton(_projectData.liveUrl, _projectData.color)			_liveLink.x = _area.width - 3			_liveLink.y = _area.height - _liveLink.height - 3			_liveLink.visible = false;						//trace('_projectData.liveUrl '+_projectData.liveUrl.length)			if(_projectData.liveUrl.length > 0) 	_liveLink.visible = true;						_button = new BlankButton()			_button.width = _area.width			_button.height = _area.height			_button.addEventListener('blankButtonRollOver', _handleBlankButtonInteract)			_button.addEventListener('blankButtonRollOut', 	_handleBlankButtonInteract)			_button.addEventListener('blankButtonClick', 	_handleBlankButtonInteract)			_button.disableButton()						_container = new Sprite()			_container.addChild(_area)			_container.addChild(_imageLoaderVisual)			_container.addChild(_imageHolder)			_container.addChild(_imageMask)						_container.addChild(_rollOverOutline)			_container.addChild(_rollOverMask)						_container.addChild(_title)			if(!_noProject)	_container.addChild(_button)			_container.addChild(_liveLink)						addChild(_container);		}				public function get noProject():Boolean		{			return _noProject;		}				public function animateIn(t:Number = .5, delay:Number = 0):void		{			_buttonRollOut(0)			//super.enable()			_button.enableButton()			_imageLoader.loadImage(_projectData.thumbImage)			TweenMax.to(this, t, {autoAlpha:1, ease:Quad.easeOut, delay:delay})		}				public function animateOut(t:Number = .5, delay:Number = 0):void		{			//super.disable()			_button.disableButton()			TweenMax.to(this, t, {autoAlpha:0, ease:Quad.easeOut, delay:delay})		}				private function _fitImage(e:PreloaderEvent):void		{			if(_imageHolder.numChildren > 0)			{				if(_imageHolder.getChildAt(0) is Bitmap)				{					Bitmap(_imageHolder.getChildAt(0)).smoothing = true				}			}						_imageHolder.width = _imageMask.width			_imageHolder.scaleY = _imageHolder.scaleX			if(_imageHolder.height < _imageMask.height)			{				_imageHolder.height = _imageMask.height				_imageHolder.scaleX = _imageHolder.scaleY			}						_imageHolder.x = int(_imageMask.x + ((_imageMask.width - _imageHolder.width) * .5))			_imageHolder.y = int(_imageMask.y + ((_imageMask.height - _imageHolder.height) * .5))			TweenMax.to(_imageHolder, .3, {autoAlpha:1, ease:Quad.easeOut})			_imageLoaderVisual.text = ''		}				private function _handleBlankButtonInteract(e:Event)		{			switch(e.type)			{				case 'blankButtonRollOver':					_buttonRollOver()					break;									case 'blankButtonRollOut':					_buttonRollOut()					break;									case 'blankButtonClick':					_buttonClick()					break;			}		}				private function _buttonRollOver():void		{			TweenMax.to(_rollOverOutline, .3, {width:_rollOverMask.width, height:_rollOverMask.height, ease:Quad.easeOut})			//TweenMax.to(_fill, .3, {x:-_fill.width, ease:Quad.easeOut})		}				private function _buttonRollOut(t:Number = .3):void		{			TweenMax.to(_rollOverOutline, t, {width:_rollOverMask.width + (_outlineWidth * 1.5), height:_rollOverMask.height + (_outlineHeight * 1.5), ease:Quad.easeOut})			//TweenMax.to(_fill, .3, {x:-15, ease:Quad.easeOut})		}				private function _buttonClick():void		{			dispatchEvent(new ProjectThumbEvent(ProjectThumbEvent.SELECT, this._projectData, true, true))		}				private function _updateLoader(e:PreloaderEvent)		{			_imageLoaderVisual.text = 'LOADING '+e.percent + '%'		}			}	}