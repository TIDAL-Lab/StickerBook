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
 * Compiles a tangible program.
 *
 * @author Michael Horn
 */
class TangibleCompiler {
   
  /** Scans image bitmap files for topcodes */
  Scanner scanner;
  
  /** Used to generate new statements from top codes */
  StatementFactory factory;
   
  /** Converts high-level text-based code to assembly code */
  //TextCompiler tcompiler;
   
  /** Header include for generated text-based code */
  //protected String header;
   
  /** Redefined skills */
  //protected Map<String, String> skills;
   
   
  TangibleCompiler() {
    scanner    = new Scanner();
    factory    = new StatementFactory(STATEMENTS);
    //tcompiler  = new TextCompiler();
    //header     = "";
    //skills     = new java.util.HashMap<String, String>();
  }
   

/**
 * Tangible compile function: generate a program from a bitmap image
 */
  Program compile(ImageData image) {
      
    Program program = new Program();

    //-----------------------------------------------------------
    // 1. Create a list of topcodes from the bitmap image
    //-----------------------------------------------------------
    List<TopCode> spots = scanner.scan(image);


    //-----------------------------------------------------------
    // 2. Convert topcodes to statements
    //-----------------------------------------------------------
    for (TopCode top in spots) {
      Statement s = factory.createStatement(top);
      if (s != null) {
        program.addStatement(s);
      }
    }


    //-----------------------------------------------------------
    // 3. Connect chains of statements together
    //-----------------------------------------------------------
    for (Statement a in program.statements) {
      for (Statement b in program.statements) {
        if (a != b) {
          a.connect(b);
        }
      }
    }

      
    //-----------------------------------------------------------
    // 4. Compile skills (subroutines)
    //-----------------------------------------------------------
    for (Statement s in program.statements) {
      if (s.isStartStatement) {
        //((tidal.tern.language.Begin)s).compileSkill(skills);
      }
    }
      
      
    //-----------------------------------------------------------
    // 5. Convert the tangible program to a text-based program
    //-----------------------------------------------------------
    String code = "";
    for (Statement s in program.statements) {
      if (s.isStartStatement) {
        code = s.compile(code, true);
      }
    }

    /*      
      String tcode = header + "\n";
      for (String skill : skills.values()) {
         tcode += skill + "\n";
      }
      
      tcode += sw.toString();
      program.setTextCode(tcode);
      Log.i(TAG, tcode);
    */
      
    //-----------------------------------------------------------
    // 6. Convert the text-based code to assembly code
    //-----------------------------------------------------------
    /*
      String pcode = tcompiler.compile(tcode);
      program.setAssemblyCode(pcode);
      Log.i(TAG, pcode);
    */

    return program;
  }
}