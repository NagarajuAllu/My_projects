package com.ericsson.stc.c2f_association.graniteService.impl.persistence;

import com.ericsson.stc.c2f_association.graniteService.pojo.GisDataPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.ShelfPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.SitePojo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.ericsson.stc.c2f_association.utility.PropertyReader;
import org.apache.log4j.Logger;

/**
 * To perform queries on the DB
 */
public class DBConnectionManager {

  private static DBConnectionManager s_instance = null;

  private Logger _logger = Logger.getLogger(getClass());

  private String _dbURL      = null;
  private String _dbUserName = null;
  private String _dbPassword = null;

  private DBConnectionManager() {
    initializeConnectionParameters();
  }

  public static DBConnectionManager getInstance() {
    if (s_instance == null) {
      s_instance = new DBConnectionManager();
    }
    return s_instance;
  }

  public SitePojo getSitePojoByCLLI(String siteCLLI) {
    SitePojo sitePojo = null;
    Connection connection = null;

    String sqlQuery = "select site_inst_id, num " +
                      "  from site_inst " +
                      " where clli = ?";

    try {
      connection = getConnection();
      if (connection != null) {
        PreparedStatement preparedStatement = connection.prepareStatement(sqlQuery);
        preparedStatement.setString(1, siteCLLI);
        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
          sitePojo = new SitePojo();
          sitePojo.setSiteInstId(resultSet.getLong(1));
          sitePojo.setType(resultSet.getString(2));
        }

        resultSet.close();
        preparedStatement.close();
        connection.rollback();
      }
    }
    catch(SQLException sqlExc) {
      _logger.error("Error in executing query to gather info for site with clli = '" + siteCLLI + "'", sqlExc);
    }
    finally {
      if (connection != null) {
        try {
          connection.close();
        }
        catch (Throwable t) {
          _logger.info("Error in closing connection in getSitePojoByCLLI", t);
        }
      }
    }

    return sitePojo;
  }

  public Long getUDAInstId(String udaGroup, String udaName) {
    Long udaInstId = null;
    Connection connection = null;

    String sqlQuery = "select val_attr_inst_id " +
                      "  from val_attr_name " +
                      " where group_name = ? " +
                      "   and attr_name = ?";

    try {
      connection = getConnection();
      if (connection != null) {
        PreparedStatement preparedStatement = connection.prepareStatement(sqlQuery);
        preparedStatement.setString(1, udaGroup);
        preparedStatement.setString(2, udaName);

        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
          udaInstId = resultSet.getLong(1);
        }

        resultSet.close();
        preparedStatement.close();
        connection.rollback();
      }
    }
    catch(SQLException sqlExc) {
      _logger.error("Error in executing query to gather udaInstId for uda <'" + udaGroup + "," + udaName + ">", sqlExc);
    }
    finally {
      closeConnection(connection);
    }

    return udaInstId;
  }

  public ShelfPojo getShelfPojoByShelfUDA(Long udaInstId, String udaValue) {
    ShelfPojo shelfPojo = null;
    Connection connection = null;

    String sqlQuery = "select ei.equip_inst_id, ei.descr, si.site_inst_id  " +
                      "  from site_inst si, equip_inst ei, equip_attr_settings eas" +
                      " where si.site_inst_id = ei.site_inst_id" +
                      "   and ei.equip_inst_id = eas.equip_inst_id" +
                      "   and ei.eq_class = ?" +
                      "   and eas.val_attr_inst_id = ?" +
                      "   and eas.attr_value = ?";

    try {
      connection = getConnection();
      if (connection != null) {
        PreparedStatement preparedStatement = connection.prepareStatement(sqlQuery);
        preparedStatement.setString(1, "S");
        preparedStatement.setLong(2, udaInstId);
        preparedStatement.setString(3, udaValue);

        ResultSet resultSet = preparedStatement.executeQuery();
        //vg, 11dec: should not be "while" here?
        //what if multiple sites found by equipment udaValue?
        if (resultSet.next()) {
          shelfPojo = new ShelfPojo();
          shelfPojo.setEquipInstId(resultSet.getLong(1));
          shelfPojo.setName(resultSet.getString(2));
          shelfPojo.setSiteInstId(resultSet.getLong(3));
        }

        resultSet.close();
        preparedStatement.close();
        connection.rollback();
      }
    }
    catch(SQLException sqlExc) {
      _logger.error("Error in executing query to gather siteInstId for eqp with uda = '" + udaValue + "'", sqlExc);
    }
    finally {
      if (connection != null) {
        try {
          connection.close();
        }
        catch (Throwable t) {
          _logger.info("Error in closing connection in getSiteInstIdByShelfUDA", t);
        }
      }
    }

    return shelfPojo;
  }

  public List<GisDataPojo> getGisData() {
    String sql =
            "select * from egi_fulfillment.GIS_PLATEID_ASSOCIATIONS_C2F " +
            "where COPPER_PLATE_ID is not null and FIBER_PLATE_ID is not null and STATUS is null";
    List<GisDataPojo> gisList = new ArrayList<>();
    Connection connection = null;
      try {
          connection = getConnection();
          if (connection != null) {
              PreparedStatement preparedStatement = connection.prepareStatement(sql);
              ResultSet resultSet = preparedStatement.executeQuery();

              while (resultSet.next()) {
                gisList.add(new GisDataPojo(resultSet.getString(1), resultSet.getString(2)));
              }

              resultSet.close();
              preparedStatement.close();
              connection.rollback();
          }
          return gisList;
      } catch (Exception e) {
          _logger.error("Error in executing query to gather input GIS data", e);
          return null;
      } finally {
        closeConnection(connection);
      }
  }

  public void updateGisResult(GisDataPojo gis) {
    String sql =
            "update egi_fulfillment.GIS_PLATEID_ASSOCIATIONS_C2F set STATUS=?, ERROR=?, EXECUTION_DATE=? " +
            "where COPPER_PLATE_ID=? and FIBER_PLATE_ID=?";
    Connection connection = null;
    try {
      connection = getConnection();
      if (connection != null) {
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, gis.getStatus());
        preparedStatement.setString(2, gis.getError());
        preparedStatement.setDate(3, gis.getExecutionDate());
        preparedStatement.setString(4, gis.getCopperPlateId());
        preparedStatement.setString(5, gis.getFiberPlateId());
        preparedStatement.executeUpdate();

        preparedStatement.close();
      }
    } catch (Exception e) {
      _logger.error("Error while updating GIS result", e);
    } finally {
      closeConnection(connection);
    }
  }

  /**
   * To gather connection parameters.
   */
  private void initializeConnectionParameters() {
    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
      PropertyReader propertyReader = PropertyReader.getInstance();
      _dbURL = propertyReader.getProperty("dbURL", "jdbc:oracle:thin:@localhost:1522/wolf12c");
      _dbUserName = propertyReader.getProperty("dbUserName", "indb_dba");
      _dbPassword = propertyReader.getProperty("dbPassword", "indb_dba");
    }
    catch (Exception exc) {
      exc.printStackTrace();
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
      _logger.debug("Connection acquired");
    }
    catch (SQLException sqlEx) {
      _logger.error("Error open connection for url: " + _dbURL + " for user : " + _dbUserName + ";  message = " + sqlEx.getMessage(), sqlEx);
      instanceConnection = null;
    }
    return instanceConnection;
  }

  private void closeConnection(Connection connection) {
    if (connection != null) {
      try {
        connection.close();
        _logger.debug("Connection closed");
      } catch (SQLException e) {
        _logger.error("Error in closing the connection", e);
      }
    }
  }







}
