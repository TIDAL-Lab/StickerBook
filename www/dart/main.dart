library StickerBook;

import 'dart:html';
import 'dart:math';
import 'dart:async';

part 'compiler.dart';
part 'connector.dart';
part 'factory.dart';
part 'program.dart';
part 'statement.dart';
part 'scanner.dart';
part 'topcode.dart';
part 'utils.dart';


CanvasRenderingContext2D c1, c2;
ImageElement image;
TangibleCompiler compiler;
VideoElement video = null;
Timer timer;
MediaStream stream;


void main() {
  CanvasElement canvas = document.query("#main-canvas");
  c1 = canvas.getContext("2d");
  //scanner = new Scanner();
  compiler = new TangibleCompiler();
  video = new VideoElement();
  video.autoplay = true;
  video.onPlay.listen((e) {
    c1.drawImage(video, 0, 0);
    timer = new Timer.periodic(const Duration(milliseconds : 30), refreshCanvas);
  });
  
  // Register mouse events
  window.onMouseDown.listen((e) => mouseDown(e));
  window.onMouseUp.listen((e) => mouseUp(e));
  window.onMouseMove.listen((e) => mouseMove(e));
  
  
  // bind button events
  bindClickEvent("camera-button", startStopVideo);
}


void startStopVideo(var event) {
  if (stream == null) {
    window.navigator.getUserMedia(
      audio : false,
      video : { 'mandatory' : { 'minWidth' : 800, 'minHeight' : 600 }}).then((var ms) {

//    window.navigator.getUserMedia(audio: false, video: true).then((var ms) {
      video.src = Url.createObjectUrl(ms);
      stream = ms;
    });
  }
  else {
    timer.cancel();
    video.pause();
    stream.stop();
    stream = null;
  }
}

void refreshCanvas(Timer timer) {
  c1.drawImage(video, 0, 0);
  ImageData id = c1.getImageData(0, 0, 960, 720);
  Program program = compiler.compile(id);
  program.draw(c1);
  /*
  List<TopCode> codes = scanner.scan(id);
  //c2.putImageData(id, 0, 0);
  for (TopCode top in codes) {
    print("got one");
    top.draw(c1);
  }
  */
}

bool mdown = false;

void mouseDown(MouseEvent e) {
  mdown = true;
}


void mouseUp(MouseEvent e) {
  mdown = false;
}


void mouseMove(MouseEvent e) {
  if (mdown) {
    /*
    int tx = e.clientX;
    int ty = e.clientY;
    ImageData id = c1.getImageData(tx - 320, ty - 240, 640, 480);
    List<TopCode> codes = scanner.scan(id);
    c2.putImageData(id, 0, 0);
    for (TopCode top in codes) {
      top.draw(c2);
    }
    */
  }
}


