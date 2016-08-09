/**
 * Created by Myself on 16/7/16.
 */
var ctx;
var radius = 30;
var coordinates=[];
var color=['rgba(139,0,255,0.4)','rgba(0,0,255,0.4)','rgba(0,127,255,0.4)','rgba(0,255,0,0.4)','rgba(255,255,0,0.4)','rgba(255,165,0,0.4)','rgba(255,0,0,0.4)']


var drawRect = function (x,y,val) {
    var style;
    for (var i=0;i<6;i++) {
        if (val>i*2 && val<=(i+1)*2){
            style = color[i];
        }
    }
    if (val>12){
        style = color[color.length-1];
    }else if (style==undefined){
        style = 'rgba(255,255,255,0)';
    }

    var param = Math.sqrt(3)/2*radius;

    ctx.beginPath();
    ctx.lineWidth =1;
    ctx.fillStyle =style;
    ctx.moveTo(x,y-radius);
    ctx.lineTo(x+param,y-radius/2);
    ctx.lineTo(x+param,y+radius/2);
    ctx.lineTo(x,y+radius);
    ctx.lineTo(x-param,y+radius/2);
    ctx.lineTo(x-param,y-radius/2);
    ctx.fill();
    ctx.closePath();


}

var drawText = function (x,y,val) {
    if (val>0){
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.font = "15px Arial";
        ctx.fillStyle = 'white';
        ctx.fillText(val,x,y);
    }
}

var newImageExtentCal = function (LNum,VNum,W3857,H3857) {
    var result1,result2;
    var result = [];

    var queue = Math.floor(Math.abs(VNum/H3857));

    if (VNum>=0){
        result1 = queue*Math.abs(H3857);
    }else {
        result1 = -1*queue*Math.abs(H3857);
    }
    result.push(result1);

    if (queue%2===0){
        result2 = Math.ceil(Math.abs(LNum/W3857))*Math.abs(W3857);
    }else {
        result2 = Math.ceil(Math.abs(LNum/W3857)-0.5)*Math.abs(W3857)+0.5*Math.abs(W3857);
    }

    if (LNum<=0){
        result2 = -1*result2;
    }
    result.push(result2);

    return result;

}

var calculateGrids = function (numOfLevel,numOfVertical,imageExtent) {
    var x,y,_currentX,_currentY;
    var paraTwo = Math.sqrt(3)/2*radius;

    var _gridW_3857 = (imageExtent[2]-imageExtent[0])/numOfLevel;
    var _gridH_3857 = (-imageExtent[3]+imageExtent[1])/numOfVertical;
    var radius_3857 = 2*_gridH_3857/3;

    var newImageExtent = newImageExtentCal(imageExtent[0],imageExtent[3],_gridW_3857,_gridH_3857);
    var newImageExtent0 = newImageExtent[1];
    var newImageExtent3 = newImageExtent[0];

    var newX = (newImageExtent0 - imageExtent[0])/_gridW_3857*2*paraTwo;
    var newY = (newImageExtent3 - imageExtent[3])/_gridH_3857*1.5*radius;

    for (var i=0;i<numOfVertical;i++){
        for (var j=0;j<numOfLevel;j++){
            if (i%2===0){
                _currentX = newX+2*paraTwo*j;
                x = newImageExtent0 + _gridW_3857*j;
            }else {
                _currentX = newX+paraTwo+2*paraTwo*j;
                x = newImageExtent0+0.5*_gridW_3857+_gridW_3857*j;    //To do i||j
            }

            _currentY = newY+1.5*radius*i;
            y = newImageExtent3+_gridH_3857*i;

            var count = 0;

            coordinates.forEach(function (coordinate) {
                var _coordinate = ol.proj.fromLonLat(coordinate);

                var xInPolygon = _coordinate[0]-x;
                var yInPolygon = _coordinate[1]-y;

                if (Math.abs(yInPolygon)>=Math.abs(radius_3857)
                    || Math.abs(xInPolygon)>=Math.abs(_gridW_3857)/2){
                    //To do
                }else {
                    if (Math.abs(radius_3857)-Math.abs(yInPolygon)>Math.abs(xInPolygon)/Math.sqrt(3)){
                        count+=1;
                    }
                }

            });
            drawRect(_currentX,_currentY,count);
            drawText(_currentX,_currentY,count);
        }
    }

}

var render = function (canvasWidth,canvasHeight,imageExtent) {
    var numOfLevel = canvasWidth/(Math.sqrt(3)*radius);
    var numOfVertical = canvasHeight/(1.5*radius);

    calculateGrids(numOfLevel,numOfVertical,imageExtent);

}

var canvasFunction = function (imageExtent,imageResolution,devicePixelRatio,imageSize,imageProjection) {
    if (!this.canvas){
        this.canvas = document.createElement('canvas');
    }

    var canvasWidth = imageSize[0];
    var canvasHeight = imageSize[1];

    this.canvas.setAttribute('width',canvasWidth);
    this.canvas.setAttribute('height',canvasHeight);

    ctx = this.canvas.getContext('2d');

    render(canvasWidth,canvasHeight,imageExtent);

    return this.canvas;

}

if(coordinates.length===0){
    for (var m=0;m<300;m++){
        var x = (Math.random()-0.5)*60;
        var y = (Math.random()-0.5)*60;
        coordinates.push([x,y]);
    }

}

var map = new ol.Map({
    layers: [
        new ol.layer.Tile({
            source: new ol.source.OSM()
        })
    ],
    target: 'map',
    view: new ol.View({
        center: [0, 0],
        zoom: 2
    })
});

var layer = new ol.layer.Image({
    source:new ol.source.ImageCanvas({
        canvasFunction: canvasFunction,
        projection: 'EPSG:3857'
    })
});

map.addLayer(layer);
