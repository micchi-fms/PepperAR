import processing.net.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;

Server server;
Capture cam;

//MultiMarker ar;
MultiNft ar;  // MultiMarkerではなくMultiNftを使う！
PImage clear;
PImage clouds;
PImage rain;

PShape c3po;

//回転させる
int timer=0;

//サーバーから送られてくるデータ(グローバル)
String s=null;
String bs="null";
//一回だけ動かす用のフラグ
boolean fadeFlag=true;
void setup(){
  size( 640, 480, P3D);
  //size(1920,1080,P3D);//6
  //size(1280,720,P3D);//8
  String [] cameras=Capture.list();
  for(int i=0;i<cameras.length;i++){
    println(i+":"+cameras[i]);
  }
  //画像
  clear=loadImage("clear.png");
  clouds=loadImage("clouds.png");
  rain=loadImage("rain.png");
  //3dmodel
  c3po=loadShape("C-3PO_v2.obj");
  //外側のカメラ
  cam = new Capture(this, cameras[2]);
    //cam = new Capture(this, cameras[8]);
  //内臓カメラ
  //cam = new Capture(this, cameras[10]);
  //frameRate(30);
  cam.start();
  ar = new MultiNft(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  //ar.addARMarker("patt.hiro", 0);
  // test.iset, test.fset, test.fset3の3つのファイルをnftFilesGenで作成
  ar.addNftTarget("mainMarker", 160);
  server = new Server(this,12345);
}
void draw(){
  if ( !cam.available() ) return;
  background(0);
  cam.read();
  ar.detect(cam);
  ar.drawBackground(cam);
  
  //以下サーバー
  Client c=server.available();
  if(c!=null){
    fadeFlag=true;
    bs=s;
    s=c.readString();
    println("server received:"+s);
    server.write(s);
  }
  if( s!=null && !s.equals(bs)&& fadeFlag){
    timer=0;
    fadeFlag=false;
  }
  if ( ar.isExist(0) && s !=null) {
    ar.beginTransform(0);
    timer+=7;
    if(s.equals("clear")){
      //fill(116, 163, 241, 100);
      //box(40);
      rotate(PI);
      translate(-clear.width/2,-clear.height/2,0);
      pushMatrix();
        rotateX(PI/10);
        translate(350,-150,0);
        scale(0.8);
        tint(255,timer);
        image(clear,0,0);
      popMatrix();

    }else if(s.equals("clouds")){
      //fill(116, 163, 241, 100);
      //box(40);
      rotate(PI);
      translate(-clouds.width/2,-clouds.height/2,0);
      pushMatrix();
        rotateX(PI/10);
        translate(350,-150,0);
        scale(0.8);
        tint(255,timer);
        image(clouds,0,0);
      popMatrix();
    }else if(s.equals("rain")){
      //fill(116, 163, 241, 100);
      //box(40);
      rotate(PI);
      translate(-rain.width/2,-rain.height/2,0);
      pushMatrix();
        rotateX(PI/10);
        translate(350,-150,0);
        scale(0.8);
        tint(255,timer);
        image(rain,0,0);
      popMatrix();
    }else if(s.equals("c3po")){
      //translate(350,-150,0);
      //fill(116, 163, 241, 100);
      //box(40);
      translate(-330,80,0);
      pushMatrix();
        scale(40);
        //rotateY(PI/2);
        shape(c3po,0,0);
      popMatrix();
    }
    ar.endTransform();
  }else{
    timer=0;
  }
  tint(255,255);
}