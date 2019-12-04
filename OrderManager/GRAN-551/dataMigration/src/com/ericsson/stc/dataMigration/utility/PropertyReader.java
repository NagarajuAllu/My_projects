package com.ericsson.stc.dataMigration.utility;

import java.util.ResourceBundle;

/**
 * This class is used to load all the resources/configuration of the application.
 */
public class PropertyReader {

  private static final String PROPERTY_FILE = "dataMigration";

  /**
   * The reference to the resource bundle.
   */
  private ResourceBundle _resourceBundle = null;
  /**
   * The unique instance of this class.
   */
  private static PropertyReader _instance;

  /**
   * The constructor of the singleton.
   */
  private PropertyReader() {
    _resourceBundle = ResourceBundle.getBundle(PROPERTY_FILE);
  }

  /**
   * To get the unique instance of this class.
   *
   * @return the unique instance of this class.
   */
  public static PropertyReader getInstance() {
    if(_instance == null) {
      _instance = new PropertyReader();
    }

    return _instance;
  }

  /**
   * Fetch parameter values from the ResourceBundle.
   *
   * @param name         the name of the attribute.
   * @return the found value if found, otherwise null.
   */
  public String getProperty(String name) {
    return getProperty(name, null);
  }

  /**
   * Fetch parameter values from the ResourceBundle.
   *
   * @param name         the name of the attribute.
   * @param defaultValue the default value of the attribute.
   * @return the found value if found, otherwise the given defaultValue.
   */
  public String getProperty(String name, String defaultValue) {
    String value = _resourceBundle.getString(name);
    return (value != null ? value : defaultValue);
  }
}
