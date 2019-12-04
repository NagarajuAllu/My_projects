package com.ericsson.stc.orderGeneration.persistentTier;

import com.ericsson.stc.orderGeneration.persistentTier.pojo.ServiceData;
import com.ericsson.stc.orderGeneration.utility.PropertyReader;
import org.apache.log4j.Logger;

import java.sql.*;
import java.util.HashMap;

public class OracleConnectionManager {

  private static OracleConnectionManager s_instance = null;

  private Logger _logger = Logger.getLogger(getClass());

  private String _dbURL      = null;
  private String _dbUserName = null;
  private String _dbPassword = null;

  private String _selectStatementForServices = null;
  private String _updateStatementForServices = null;

  private OracleConnectionManager() {
    initializeConnectionParameters();
    extractStatements();
  }

  public static OracleConnectionManager getInstance() {
    if(s_instance == null) {
      s_instance = new OracleConnectionManager();
    }

    return s_instance;
  }

  /**
   * To gather connection parameters.
   */
  private void initializeConnectionParameters() {
    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
      PropertyReader reader = PropertyReader.getInstance();
      _dbURL = reader.getProperty("dbInputURL");
      _dbUserName = reader.getProperty("dbInputUserName");
      _dbPassword = reader.getProperty("dbInputPassword");
    }
    catch (Exception exc) {
      _logger.error("Error in initializing connections parameters", exc);
    }
  }

  private void extractStatements() {
    PropertyReader reader = PropertyReader.getInstance();
    _selectStatementForServices = reader.getProperty("dbQueryStringForService");
    if(_selectStatementForServices == null) {
      _logger.error("Unable to get the 'dbQueryStringForService' statement from the configuration file");
    }

    _updateStatementForServices = reader.getProperty("dbUpdateResultStringForService");
    if(_updateStatementForServices == null) {
      _logger.error("Unable to get the 'dbUpdateResultStringForService' statement from the configuration file");
    }
  }

  /**
   * To load XML string.
   */
  public HashMap<String, ServiceData> extractAllRecordsForServices() {
    Connection connection = null;

    HashMap<String, ServiceData> result = new HashMap<>();
    try {
      connection = getConnection();

      if (connection != null) {

        if(_selectStatementForServices != null) {
          PreparedStatement preparedStatementForSelect = connection.prepareStatement(_selectStatementForServices);
          ResultSet rs = preparedStatementForSelect.executeQuery();
          while (rs.next()) {
            ServiceData serviceData = new ServiceData();
            // customer data
            serviceData.setCustomerRef(rs.getString("CUSTOMER_REF"));
            serviceData.setCustomerType(rs.getString("CUSTOMER_TYPE"));
            serviceData.setCustomerSubType(rs.getString("CUSTOMER_SUBTYPE"));
            serviceData.setCustomerIdType(rs.getString("ID_TYPE"));
            serviceData.setCustomerIdNO(rs.getString("ID_NO"));
            serviceData.setCustomerSegment(rs.getString("SEGMENT"));
            serviceData.setCustomerAccountNO(rs.getString("ACCOUNT_NO"));
            serviceData.setCustomerServiceNumber(rs.getString("SERVICE_NUMBER"));
            serviceData.setCustomerSne(rs.getString("SNE"));
            serviceData.setCustomerServiceCode(rs.getString("SERVICE_CODE"));
            serviceData.setCustomerSneStartDt(rs.getString("SNE_START_DT"));
            serviceData.setCustomerAccessNumber(rs.getString("ACCESS_NUMBER"));
            serviceData.setCustomerMigrationResult(rs.getInt("CUST_MIGRATION_RESULT"));

            //serviceData
            serviceData.setPathName(rs.getString("PATH_NAME"));
            serviceData.setServiceCustomerNumber(rs.getString("SERVICE_CUSTOMER_NUMBER"));
            serviceData.setAccountNumber(rs.getString("ACCOUNT_NUMBER"));
            serviceData.setServiceNumber(rs.getString("SERVICE_NUMBER"));
            serviceData.setAccessNumber(rs.getString("ACCESS_NUMBER"));
            serviceData.setSamControlNumber(rs.getString("SAM_CONTROL_NUMBER"));
            serviceData.setCityCode(rs.getString("CITY_CODE"));
            serviceData.setDistrictCode(rs.getString("DISTRICT_CODE"));
            serviceData.setDescription(rs.getString("DESCRIPTION"));
            serviceData.setPlateId(rs.getString("PLATE_ID"));
            serviceData.setType(rs.getString("TYPE"));
            serviceData.setSiteA(rs.getString("SITE_A"));
            serviceData.setSiteB(rs.getString("SITE_B"));
            serviceData.setFunctionCode(rs.getString("FUNCTION_CODE"));
            serviceData.setComputedSiteA(rs.getString("COMPUTED_SITE_A"));
            serviceData.setComputedSiteB(rs.getString("COMPUTED_SITE_B"));
            serviceData.setOrderNumber(rs.getString("ORDER_NUMBER"));

            result.put(serviceData.getPathName(), serviceData);
          }
          preparedStatementForSelect.close();

          connection.rollback();
        }
        else { // if (_selectStatementForServices != null)
          _logger.error("Statement for search is missing; see previous logs");
          result = null;
        }
      }
      else { // if (connection != null)
        _logger.error("Connection failed; see previous logs");
        result = null;
      }
    }
    catch (SQLException sqlExc) {
      _logger.error("Unable to gather the info for SERVICE from the DB due to SQL exception;  message = " + sqlExc.getMessage(), sqlExc);
      result = null;
    }
    finally {
      if(connection != null) {
        try {
          connection.close();
        }
        catch(Throwable t) {
          _logger.error("Error in closing connection with the DB", t);
        }
      }
    }
    return result;
  }

  /**
   * To update the dumped field.
   */
  public void markRecordAsProcessed(String pathName, Integer resultValue) {
    Connection connection = null;

    try {
      connection = getConnection();

      if (connection != null) {
        if(_updateStatementForServices != null) {
          PreparedStatement preparedStatementForUpdate = connection.prepareStatement(_updateStatementForServices);
          preparedStatementForUpdate.setString(2, pathName);
          preparedStatementForUpdate.setInt(1, resultValue);
          int rowsUpdated = preparedStatementForUpdate.executeUpdate();
          if(rowsUpdated > 0) {
            _logger.debug("Record with pathName '" + pathName + "' updated with value '" + resultValue + "'");
          }
          else {
            _logger.error("Unable to find record with pathName '" + pathName + "'");
          }
          preparedStatementForUpdate.close();

          connection.commit();
        }
      }
      else { // if (connection != null)
        _logger.error("Connection failed; see previous logs");
      }
    }
    catch (SQLException sqlExc) {
      _logger.error("Unable to update the info for SERVICE from the DB due to SQL exception; DB Error: " + sqlExc.getMessage(), sqlExc);
    }
    finally {
      if(connection != null) {
        try {
          connection.close();
        }
        catch(Throwable t) {
          _logger.error("Error in closing connection", t);
        }
      }
    }

  }

  /**
   * To get the connection to the DB.
   * @return the connection to the DB or null if any error occurs.
   */
  private Connection getConnection() {
    _logger.debug("Getting connection...");

    Connection instanceConnection;
    try {
      instanceConnection = DriverManager.getConnection(_dbURL, _dbUserName, _dbPassword);
      instanceConnection.setAutoCommit(false);
      _logger.debug("connection acquired...");
    }
    catch (SQLException sqlEx) {
      _logger.error("Unable to connect to the DB with the provided information. Please double-check the configuration file");
      _logger.error("  url: " + _dbURL + "; user : " + _dbUserName, sqlEx);
      instanceConnection = null;
    }
    return instanceConnection;
  }
}
