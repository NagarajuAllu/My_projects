package com.ericsson.stc.orderGeneration.businessTier;

public class InvokerException extends Exception {
  public InvokerException() {
    super();
  }

  public InvokerException(String message) {
    super(message);
  }

  public InvokerException(Throwable cause) {
    super(cause);
  }

  public InvokerException(String message, Throwable cause) {
    super(message, cause);
  }
}
