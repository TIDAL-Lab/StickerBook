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


/**
 * A base class for all tangible language statements. A statement is
 * any element that can be connected in a program's flow-of-control.
 * A statement must have at least one socket or one connector (most
 * have both a socket and a connector). Statements have no implicit
 * data type and carry no return value.
 */
class Statement {
   
  static int NEST = 0;


  /** TopCode for this statement */
  TopCode top = null;
   
  /** Name of the statement */
  String name = '';

  /** Image source */
  String image = '';
   
  /** Is this statement a start statement */
  bool start = false;
  
  /** Is this statement an end statement */
  bool end = false;

  /** List of connectors (ingoing, outgoing, and params) for this statement */
  List<Connector> connectors;
   
   
  Statement(this.top) {
    connectors = new List<Connector>();
  }
  
    
  factory Statement.fromJSON(var d) {
    TopCode top = new TopCode();
    top.code = d['code'];
    Statement s;
    //if (d.containsKey('class')) {
      
    //} else {
      s = new Statement(top);
    //}

    s.name = d['name'];
    s.image = d['image'];
    if (d['start']) s.start = true;
    if (d['end']) s.end = true;
    if (d.containsKey('socket')) {
      Connector c = new Connector(s, TYPE_IN, 'prev', 0.0, 0.0);
      if (d['socket'] is Map && d['socket'].containsKey('dx') && d['socket'].containsKey('dy')) {
        c.dx = d['socket']['dx'];
        c.dy = d['socket']['dy'];
      }
      s.addConnector(c);
    }
    
    if (d.containsKey('plug')) {
      Connector c = new Connector(s, TYPE_OUT, 'next', 1.7, 0.0);
      if (d['plug'] is Map && d['plug'].containsKey('dx') && d['plug'].containsKey('dy')) {
        c.dx = d['socket']['dx'];
        c.dy = d['socket']['dy'];
      }
      s.addConnector(c);
    }
    return s;
  }
  
  
/**
 * Clone the current statement
 */
  Statement clone(TopCode top) {
    Statement s = new Statement(top);
    _copy(s);
    return s;
  }
  
  
  void _copy(Statement other) {
    other.name = this.name;
    other.image = this.image;
    other.start = this.start;
    other.end = this.end;
    for (Connector c in connectors) {
      other.addConnector(c.clone(other));
    }
  }


  void addConnector(Connector con) {
    connectors.add(con);
  }
   
   
  List<Connector> getConnectors() {
    return connectors;
  }
  
  
  bool get hasTopCode { return top != null; }
   

  bool hasConnection(String name) {
    for (Connector c in connectors) {
      if (name == c.name) {
        return c.hasConnection;
      }
    }
    return false;
  }
  
  
  bool get hasIncomingConnection {
    for (Connector c in connectors) {
      if (c.isIncoming && c.hasConnection) {
        return true;
      }
    }
    return false;
  }
   
   
  Statement getConnection(String name) {
    for (Connector c in connectors) {
      if (name == c.name) {
        return c.getConnection();
      }
    }
    return null;
  }
  
  
  Statement getNextStatement() {
    for (Connector c in connectors) {
      if (c.isOutgoing && c.hasConnection) {
        return c.getConnection();
      }
    }
    return null;
  }
   
   
  bool get isCompleteProgram {
    if (end) {
      return true;
    } else {
      for (Connector c in connectors) {
        if (c.isOutgoing && c.hasConnection) {
          if (c.getConnection().isCompleteProgram) {
            return true;
          }
        }
      }
    }
    return false;
  }


  bool get isStartStatement => start;
  
  bool get isEndStatement => end;
   
   
  void connect(Statement other) {
    for (Connector plug in connectors) {
      if (plug.isOutgoing || plug.isParameter) {
        for (Connector socket in other.connectors) {
          if (socket.isIncoming) {
            if (socket.overlaps(plug)) {
              plug.setConnection(other);
              socket.setConnection(other);
            }
          }
        }
      }
    }
  }
}


class Repeat extends Statement {
  
  Repeat(TopCode top) : super(top);
  
  
  Statement clone(TopCode top) {
    Statement s = new Repeat(top);
    _copy(s);
    return s;
  }
}


class EndRepeat extends Statement {
  
  EndRepeat(TopCode top) : super(top);
  
  
  Statement clone(TopCode top) {
    Statement s = new EndRepeat(top);
    _copy(s);
    return s;
  }
}

