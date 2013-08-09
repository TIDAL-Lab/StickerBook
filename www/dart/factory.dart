/*
 * Tern Tangible Programming Language
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
part of StickerBook;


class StatementFactory {

  Map<int, Statement> statements;
  
  
  StatementFactory(var definitions) {
    statements = new Map<int, Statement>();
    for (var def in definitions) {
      print("${def['name']}");
      Statement s = new Statement.fromJSON(def);
      statements[def['code']] = s;
    }
  }
  

/**
 * Called by the tangible compiler to generate new statements
 * from topcodes found in an image.
 */
  Statement createStatement(TopCode top) {
    if (statements.containsKey(top.code)) {
      return statements[top.code].clone(top);
    } else {
      return null;
    }
  }
}



var STATEMENTS = [
  
  // start
  {
    'code' : 569,
    'name' : 'Begin',
    'start' : true,
    'image' : 'begin',
    'plug' : true
  },
  
  // end
  {
    'code' : 369,
    'name' : 'End',
    'end' : true,
    'image' : 'end',
    'socket' : true
  },
  
  // jump
  {
    'code' : 307,
    'name' : 'Jump',
    'image' : 'jump',
    'socket' : true,
    'plug' : true
  },
  
  // run
  {
    'code' : 185,
    'name' : 'Run',
    'image' : 'run',
    'socket' : true,
    'plug' : true
  },
  
  // walk
  {
    'code' : 405,
    'name' : 'Walk',
    'image' : 'walk',
    'socket' : true,
    'plug' : true
  },
  
  // shake
  {
    'code' : 557,
    'name' : 'Shake',
    'image' : 'shake',
    'socket' : true,
    'plug' : true
  },
  
  // sleep
  {
    'code' : 661,
    'name' : 'Sleep',
    'image' : 'sleep',
    'socket' : true,
    'plug' : true
  },
  
  // sit
  {
    'code' : 397,
    'name' : 'Sit',
    'image' : 'sit',
    'socket' : true,
    'plug' : true
  },
  
  // stand
  {
    'code' : 1189,
    'name' : 'Stand',
    'image' : 'stand',
    'socket' : true,
    'plug' : true
  },
  
  // spin
  {
    'code' : 331,
    'name' : 'Spin',
    'image' : 'spin',
    'socket' : true,
    'plug' : true
  },
  
  // tap sensor
  {
    'code' : 491,
    'name' : 'Tap Sensor',
    'socket' : { },
    'plug' : { 'dx' : 3, 'dy' : 0 }
  },
  
  // begin repeat
  {
    'code' : 171,
    'name' : 'Begin Repeat',
    'image' : 'repeat',
    'class' : 'RepeatStatement',
    'duration' : 5,
    'socket' : { 'dx' : -0.2, 'dy' : 0 },
    'plug' : { 'dx' : 1.5, 'dy' : 0 },
    'param' : { 'dx' : 0, 'dy' : -3 }
  },
  
  // end repeat
  {
    'code' : 179,
    'name' : 'End Repeat',
    'image' : 'end-repeat',
    'class' : 'EndRepeatStatement',
    'duration' : 5,
    'socket' : { 'dx' : -0.2, 'dy' : 0 },
    'plug' : { 'dx' : 1.5, 'dy' : 0 }
  },
  
  // wait for
  {
    'code' : 611,
    'name' : 'Wait For',
    'image' : 'wait',
    'socket' : true,
    'plug' : true
  },
  
  // number 2
  {
    'code' : 327,
    'name' : '2',
    'value' : 2,
    'socket' : true
  },
  
  // number 3
  {
    'code' : 205,
    'name' : '3',
    'value' : 3,
    'socket' : true
  },
  
  // number 4
  {
    'code' : 103,
    'name' : '4',
    'value' : 4,
    'socket' : true
  }  
];

	
