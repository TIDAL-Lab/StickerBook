/*
 * Roberto StickerBook
 * Copyright (c) 2013 Michael S. Horn
 * 
 *           Michael S. Horn (michael-horn@northwestern.edu)
 *           Northwestern University
 *           2120 Campus Drive
 *           Evanston, IL 60613
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License (version 2) as
 * published by the Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
library StickerBook;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:web_audio';

part 'compiler.dart';
part 'connector.dart';
part 'factory.dart';
part 'program.dart';
part 'scanner.dart';
part 'sounds.dart';
part 'statement.dart';
part 'topcode.dart';
part 'utils.dart';


const VIDEO_WIDTH = 800;
const VIDEO_HEIGHT = 600;


CanvasRenderingContext2D c1;
ImageElement image;
ImageElement backdrop;
TangibleCompiler compiler;
VideoElement video = null;
Timer timer;
MediaStream stream;
double pulse = 0.0;
Program program;


void main() {
  
  Sounds.loadSound('ding');
  Sounds.loadSound('ping');
  
  CanvasElement canvas = querySelector("#main-canvas");
  c1 = canvas.getContext("2d");
  //scanner = new Scanner();
  compiler = new TangibleCompiler();
  video = new VideoElement();
  video.autoplay = true;
  video.onPlay.listen((e) {
    setHtmlOpacity('toolbar', 0.0);
    program = null;
    c1.drawImage(video, 0, 0);
    timer = new Timer.periodic(const Duration(milliseconds : 30), refreshCanvas);
  });
  
  backdrop = new ImageElement();
  backdrop.src = "images/backdrop.png";
  
  // bind button events
  bindClickEvent("camera-button", startStopVideo);
  bindClickEvent("play-button", (event) { playPause(); });
  bindClickEvent("restart-button", (event) { restart(); });
}


/*
 * Start / stop the video stream
 */
void startStopVideo(var event) {
  if (stream == null) {
    startVideo();
  } else {
    stopVideo();
  }
}


void startVideo() {
  if (stream == null) {
    restart();
    var vconfig = {
      'mandatory' : {
        'minWidth' : VIDEO_WIDTH,
        'minHeight' : VIDEO_HEIGHT
      }
    };
    window.navigator.getUserMedia(audio : false, video : vconfig).then((var ms) {
      print("hello");
      video.src = Url.createObjectUrl(ms);
      stream = ms;
    });
  }
}


void stopVideo() {
  print("stop video");
  if (stream != null && timer != null) {
    timer.cancel();
    video.pause();
    stream.stop();
    stream = null;
    setHtmlOpacity('scan-message', 0.0);
    pulse = 0.0;
  }
}


/*
 * Called 30 frames a second
 */
void refreshCanvas(Timer timer) {
  
  pulse += 0.08;
  if (pulse > 1.0) pulse = 0.0;
  
  // draw a frame from the video stream onto the canvas
  c1.drawImage(video, 0, 0);
  
  // grab a bitmap from the canvas
  ImageData id = c1.getImageData(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
  program = compiler.compile(id);
  program.draw(c1);
  
  // scan line
  double op = (sin(pulse * 2 * PI) + 1.0) * 0.5;
  c1.strokeStyle = "rgba(255, 0, 0, $op)";
  c1.lineWidth = 1.5;
  c1.strokeRect(40, 40, VIDEO_WIDTH - 80, VIDEO_HEIGHT - 80);
  
  // STATUS: Looking for stickers...
  if (program.isEmpty) {
    setHtmlText('scan-message', 'Looking for stickers...');
    setHtmlOpacity('scan-message', 1.0);
  }
  
  // STATUS: Looking for BEGIN...
  else if (!program.hasStartStatement) {
    setHtmlText('scan-message', 'Looking for BEGIN sticker...');
    setHtmlOpacity('scan-message', 1.0);
  }
  
  // STATUS: Looking for END...
  else if (!program.hasEndStatement) {
    setHtmlText('scan-message', 'Looking for END sticker...');
    setHtmlOpacity('scan-message', 1.0);
  }
  
  // STATUS: Can't connect ...
  else if (!program.isComplete) {
    setHtmlText('scan-message', "Can't connect BEGIN sticker to END sticker...");
    setHtmlOpacity('scan-message', 1.0);
  }
  
  // STATUS:  Found program!
  else {
    Sounds.playSound('ping');
    setHtmlText('scan-message', "Found program!");
    setHtmlOpacity('scan-message', 0.0);
    setHtmlOpacity('toolbar', 1.0);
    stopVideo();
    program.restart();
    Rectangle bounds = program.getBounds;
    id = c1.getImageData(bounds.left, bounds.top, bounds.width, bounds.height);
    c1.fillStyle = "white";
    c1.fillRect(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
    c1.strokeStyle = "green";
    c1.strokeRect(bounds.left, bounds.top, bounds.width, bounds.height);
    c1.putImageData(id, bounds.left, bounds.top);    
  }
}


void animate(Timer timer) {
  if (program.isDone) {
    restart();
  }
  else if (program.isPlaying) {
    program.step();
    c1.fillStyle = 'white';
    c1.fillRect(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
    //c1.drawImage(backdrop, 0, 0);
    c1.fillStyle = 'black';
    c1.font = '26pt sans-serif';
    c1.textAlign = 'center';
    c1.textBaseline = 'bottom';
    c1.fillText(program.message, VIDEO_WIDTH ~/ 2, VIDEO_HEIGHT - 22);
    
    int iw = program.illustration.width;
    int ih = program.illustration.height;
    if (program.illustration.src != null && program.illustration.src != '') {
      c1.drawImage(program.illustration,
                   VIDEO_WIDTH ~/ 2 - iw ~/ 2,
                   VIDEO_HEIGHT ~/ 2 - ih ~/ 2);
    }
    iw = program.block.width;
    ih = program.block.height;
    c1.drawImage(program.block,  50, 50);
  }
  else {
    restart();
  }
}


void restart() {
  setBackgroundImage('play-button', 'images/play.png');
  if (program != null && program.isComplete) {
    program.restart();
    timer.cancel();
  }
}


void play() {
  setBackgroundImage('play-button', 'images/pause.png');
  if (program != null && program.isComplete) {
    program.play();
    timer = new Timer.periodic(const Duration(milliseconds : 100), animate);
  }
}


void pause() {
  setBackgroundImage('play-button', 'images/play.png');
  if (program != null && program.isComplete) {
    program.pause();
    timer.cancel();
  }
}


void playPause() {
  if (program != null && program.isComplete) {
    if (program.isPlaying) {
      pause();
    } else {
      play();
    }
  }
}

  
  
