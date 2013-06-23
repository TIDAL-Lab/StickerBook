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
      statements[def['code']] = _fromJSON(def);
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
  
  
  Statement _fromJSON(var d) {
    TopCode top = new TopCode();
    top.code = d['code'];
    Statement s = new Statement(top);
    s.name = d['name'];
    s.text = d['text'];
    if (d['start']) s.start = true;
    if (d.containsKey('socket')) {
      s.addConnector(new Connector(s, TYPE_IN, 'prev', 0.0, 0.0));
    }
    
    if (d.containsKey('plug')) {
      s.addConnector(new Connector(s, TYPE_OUT, 'next', 1.7, 0.0));
    }
    return s;
  }
   

/*   
  private static Statement newStatement(XmlResourceParser xml) throws Exception {
         
    // Create a Statement of the appropriate type
    String cname = xml.getAttributeValue(null, "class");
    if (cname == null) cname = "tidal.tern.compiler.Statement";
    Statement s = (Statement)(Class.forName(cname)).newInstance();
    

    // Set the name and topcode value
    s.setName(xml.getAttributeValue(null, "name"));
    s.setTopCode(new TopCode(xml.getAttributeIntValue(null, "code", 0)));
    s.setStartStatement(toBoolean(xml.getAttributeValue(null, "start")));
    return s;
  }
  */ 
  /*
   private static Connector newConnector(Statement s, XmlResourceParser xml) {
      int type = Connector.TYPE_IN;
      if ("socket".equals(xml.getName())) {
         type = Connector.TYPE_IN;
      } else if ("plug".equals(xml.getName())) {
         type = Connector.TYPE_OUT;
      } else if ("param".equals(xml.getName())) {
         type = Connector.TYPE_PARAM;
      }
      
      String name = xml.getAttributeValue(null, "name");
      if (name == null) name = "";
      
      String sdx = xml.getAttributeValue(null, "dx");
      String sdy = xml.getAttributeValue(null, "dy");
      
      return new Connector(s, type, name, toFloat(sdx), toFloat(s'dy'));
  }
  */
}

var STATEMENTS = [
  
  // start
  {
    'code' : 569,
    'name' : 'Begin',
    'start' : true,
    'text' : 'Begin',
    'plug' : { 'dx' : 1.83, 'dy' : 0 }
  },
  
  // end
  {
    'code' : 369,
    'name' : 'End',
    'text' : '(end)',
    'socket' : { }
  },
  
  // jump
  {
    'code' : 307,
    'name' : 'Jump',
    'text' : '(jump)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // run
  {
    'code' : 185,
    'name' : 'Run',
    'text' : '(run)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // walk
  {
    'code' : 405,
    'name' : 'Walk',
    'text' : '(walk)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // wiggle
  {
    'code' : 557,
    'name' : 'Wiggle',
    'text' : '(wiggle)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // sleep
  {
    'code' : 661,
    'name' : 'Sleep',
    'text' : '(sleep)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // sit
  {
    'code' : 397,
    'name' : 'Sit',
    'text' : '(sit)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // stand
  {
    'code' : 1189,
    'name' : 'Stand',
    'text' : '(stand)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
  },
  
  // spin
  {
    'code' : 331,
    'name' : 'Spin',
    'text' : '(spin)',
    'socket' : { },
    'plug' : { 'dx' : 3.4, 'dy' : 0 }
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
    'text' : '(repeat)',
    'socket' : { 'dx' : -0.1, 'dy' : 1.42 },
    'plug' : { 'dx' : 1.5, 'dy' : 1.42 }
  },
  
  // end repeat
  {
    'code' : 179,
    'name' : 'End Repeat',
    'socket' : { 'dx' : 0, 'dy' : 1.42 },
    'plug' : { 'dx' : 1.5, 'dy' : 1.42 }
  },
  
  // wait for
  {
    'code' : 611,
    'name' : 'Wait For',
    'text' : '(wait-for)',
    'socket' : { },
    'plug' : { 'dx' : 4.5, 'dy' : 0 }
  }
];

	
