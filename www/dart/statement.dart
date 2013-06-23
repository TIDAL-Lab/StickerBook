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
   
  static int COMPILE_ID = 0;
   
  static int NEST = 0;


  /** Name of the statement */
  String name = '';

  /** TopCode for this statement */
  TopCode top = null;
   
  /** Code that this statement generates */
  String text = '';
   
  /** Is this statement a start statement */
  bool start = false;

  /** Statement's unique compile-time ID number */
  int c_id;
   
  /** List of connectors (ingoing, outgoing, and params) for this statement */
  List<Connector> connectors;
   
   
  Statement(this.top) {
    c_id = COMPILE_ID++;
    connectors = new List<Connector>();
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
   
   
/**
 * Translates a tangible statement into a text-based representation
 */
  String compile(String code, bool debug) {
    if (debug) code = code + "trace ${c_id}";
    if (debug) code = code + 'print "${name}"';
    code = code + text;
    return compileNext(code, debug);
  }
   
   
  String compileNext(String code, bool debug) {
    for (Connector c in connectors) {
      if (c.isOutgoing && c.hasConnection) {
        code += c.getConnection().compile(code, debug);
      }
    }
    return code;
  }


/**
 * Clone the current statement
 */
  Statement clone(TopCode top) {
    Statement s = new Statement(top);
    s.name = name;
    s.text = text;
    s.start = start;
    for (Connector c in connectors) {
      s.addConnector(c.clone(s));
    }
    return s;
  }

  
  bool get isStartStatement {
    return start;
  }
   
   
  void setStartStatement(bool start) {
    start = start;
  }
   
   
  int get compileId => c_id;
   
   
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
  
  
  void draw(CanvasRenderingContext2D ctx) {
    
  }
  
}   

