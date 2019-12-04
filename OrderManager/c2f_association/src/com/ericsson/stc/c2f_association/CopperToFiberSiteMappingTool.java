package com.ericsson.stc.c2f_association;

import com.ericsson.stc.c2f_association.graniteService.GraniteService;
import com.ericsson.stc.c2f_association.graniteService.impl.GraniteServiceImpl;
import com.ericsson.stc.c2f_association.utility.PropertyReader;
import org.apache.log4j.Logger;

import java.io.*;

/**
 * The main of the tool
 */
public class CopperToFiberSiteMappingTool {

  private Logger _log = Logger.getLogger(CopperToFiberSiteMappingTool.class);
  private PropertyReader _propertyReader = PropertyReader.getInstance();
  private GraniteService _graniteServiceImpl = null;

  public static void main(String[] args) {
    CopperToFiberSiteMappingTool copperToFiberSiteMappingTool = new CopperToFiberSiteMappingTool();

    boolean valid = copperToFiberSiteMappingTool.validateInputParameters(args);
    if(!valid) {
      System.exit(-1);
    }

    copperToFiberSiteMappingTool.processInputFile(args[0]);
  }

  private boolean validateInputParameters(String[] args) {
    boolean valid = true;
    if(args.length != 1) {
      _log.error("Wrong Number of Input parameters: expected 1, Received " + args.length);
      valid = false;
    }

    if(valid) {
      String inputFileName = args[0];
      File inputFile = new File(inputFileName);
      if (!inputFile.exists()) {
        _log.error("Provided input parameter '" + inputFileName + "' refers to a file that doesn't exist");
        valid = false;
      }
      else if (!inputFile.isFile()) {
        _log.error("Provided input parameter '" + inputFileName + "' refers to a not regular file");
        valid = false;
      }
      else if (!inputFileName.toLowerCase().endsWith(".dat")) {
        _log.error("Provided input parameter '" + inputFileName + "' has the wrong extension; expected '.dat'");
        valid = false;
      }

      if (valid) {
        String reportFileName = getReportFileName(inputFileName);
        File outputFile = new File(reportFileName);

        if (outputFile.exists()) {
          _log.error("Provided input parameter '" + inputFileName + "' refers to a file already processed; report file already exists");
          valid = false;
        }
      }

      if (valid) {
        String renamedFileName = getRenamedFileName(inputFileName);
        File outputFile = new File(renamedFileName);

        if (outputFile.exists()) {
          _log.error("Provided input parameter '" + inputFileName + "' refers to a file already processed; renamed file already exists");
          valid = false;
        }
      }
    }

    if(!valid) {
      _log.error("Usage: java CopperToFiberSiteMappingTool <input mapping file>");
    }

    return valid;
  }

  private void processInputFile(String inputFileName) {
    FileInputStream fileInputStream = null;
    InputStreamReader inputStreamReader = null;
    BufferedReader bufferedReader = null;
    FileOutputStream fileOutputStream = null;
    PrintStream printStream = null;

    String fieldSeparator = _propertyReader.getProperty("fieldSeparator", ",");
    String associationName = _propertyReader.getProperty("associationName", "Copper to Fiber");

    try {
      fileInputStream = new FileInputStream(inputFileName);
      inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
      bufferedReader = new BufferedReader(inputStreamReader);

      String reportFileName = getReportFileName(inputFileName);
      fileOutputStream = new FileOutputStream(reportFileName, false);
      printStream = new PrintStream(fileOutputStream, true);

      String currentLine = bufferedReader.readLine();
      String resultForAssociation;
      long row = 1;

      while (currentLine != null) {
        currentLine = currentLine.replace("\uFEFF", ""); // to remove the BOM for UTF-8
        _log.debug("row " + row + "# currentLine = " + currentLine);

        resultForAssociation = createAssociationForSingleRow(currentLine,
                                                             fieldSeparator,
                                                             associationName);

        printStream.println(currentLine + fieldSeparator + resultForAssociation);

        currentLine = bufferedReader.readLine();
        row++;
      }
    }
    catch (Throwable exc) {
      _log.error("Unexpected error", exc);
    }
    finally {
      if(_graniteServiceImpl != null) {
        try {
          _graniteServiceImpl.shutdownASIFactory();
        }
        catch (Exception exc) {
          _log.error("Error in shutting down ASI Factory", exc);
        }
      }

      if (bufferedReader != null) {
        try {
          bufferedReader.close();
        }
        catch (Exception exc) {
          _log.error("Error in closing input bufferedReader", exc);
        }
      }

      if (inputStreamReader != null) {
        try {
          inputStreamReader.close();
        }
        catch (Exception exc) {
          _log.error("Error in closing input inputStreamReader", exc);
        }
      }

      if (fileInputStream != null) {
        try {
          fileInputStream.close();
        }
        catch (Exception exc) {
          _log.error("Error in closing input fileInputStream", exc);
        }
      }

      if (printStream != null) {
        try {
          printStream.close();
        }
        catch (Exception exc) {
          _log.error("Error in closing report printStream", exc);
        }
      }

      if (fileOutputStream != null) {
        try {
          fileOutputStream.close();
        }
        catch (Exception exc) {
          _log.error("Error in closing report fileOutputStream", exc);
        }
      }

      renameInputFile(inputFileName);
    }
  }

  private String createAssociationForSingleRow(String inputString, String fieldSeparator, String associationName) {
    String resultMsg = null;
    int separatorPosition = -1;

    if(inputString == null || inputString.trim().length() == 0) {
      resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_noInputData");
    }

    if(resultMsg == null) {
      separatorPosition = inputString.indexOf(fieldSeparator);
      if(separatorPosition < 0) {
        resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_noSeparator");
      }
      else if(separatorPosition == 0) {
        resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_missingInputFiberPlateID");
      }
      else if(separatorPosition == inputString.length() - 1) {
        resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_missingInputCopperPlateID");
      }
    }

    if(resultMsg == null) {
      String copperPlateId = inputString.substring(0, separatorPosition);
      String fiberPlateId = inputString.substring(separatorPosition + 1);

      try {
        if(_graniteServiceImpl == null) {
          _graniteServiceImpl = new GraniteServiceImpl();
          _graniteServiceImpl.startupASIFactory();
        }
        resultMsg = _graniteServiceImpl.createAssociationFromCopperToFiber(associationName, copperPlateId, fiberPlateId);
      }
      catch(Throwable exc) {
        _log.error("Unexpected error while creating the association between <" +
                   copperPlateId + "," + fiberPlateId + ">", exc);
        resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_unexpectedErrorForException") + exc.getMessage();
      }
    }

    return resultMsg;
  }

  private void renameInputFile(String inputFileName) {
    String renamedFileName = getRenamedFileName(inputFileName);
    File inputFile = new File(inputFileName);
    File renamedFile = new File(renamedFileName);
    boolean resultRename = inputFile.renameTo(renamedFile);
    if(! resultRename) {
      _log.error("Error in renaming input file " + inputFileName + " into " + renamedFileName);
    }
  }

  private String getReportFileName(String inputFileName) {
    return inputFileName.substring(0, inputFileName.length() - 4) + ".rpt";
  }

  private String getRenamedFileName(String inputFileName) {
    return inputFileName.substring(0, inputFileName.length() - 4) + ".processed";
  }
}


