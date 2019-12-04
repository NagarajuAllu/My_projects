package com.ericsson.stc.dataMigration.graniteServiceTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.KeyPojo;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.UdaASIList;
import com.granite.asi.dto.clientview.*;
import com.granite.asi.key.Key;
import com.granite.asi.key.generated.CustomerKey;
import com.granite.asi.service.CustomerService;
import com.granite.asi.service.LockService;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;

import java.util.ArrayList;

public class GraniteCustomerServiceImpl {

  private final Logger         _log            = Logger.getLogger(getClass());

  private ArrayList<CustomerUDAInfo> _customerUDAs = null;

  public GraniteCustomerServiceImpl() {
    _customerUDAs = new ArrayList<>(3);
    _customerUDAs.add(0, new CustomerUDAInfo("Customer Information", "SubType"));
    _customerUDAs.add(1, new CustomerUDAInfo("Customer Information", "Customer ID Type"));
    _customerUDAs.add(2, new CustomerUDAInfo("Customer Information", "AccountNumber"));
  }


  public KeyPojo createNewCustomer(String customerId, String customerName, String customerType,
                                   String status, String customerSubTypeUDAValue, String idTypeUDAValue,
                                   String accountNoUDAValue) throws Exception {
    KeyPojo customerKey = null;

    AsiServices asiServices = AsiServices.getInstance();
    CustomerService customerService = asiServices.getCustomerService();

    Customer customer = asiServices.getNewCustomer();
    customer.setCustomerId(customerId);
    customer.setName(customerName);
    customer.setType(customerType);
    customer.setStatus(status);

    Key insertedCustomerKey = customerService.insert(customer);
    if(insertedCustomerKey != null) {
      customer = getCustomerByInstId(insertedCustomerKey.getInstId());
      UdaASIList udaASIList = customer.getUdas();

      // UDA "Customer Information" -> "SubType"
      Uda newUdaSubType = asiServices.getNewUda();
      newUdaSubType.setGroupName(_customerUDAs.get(0).getUdaGroup());
      newUdaSubType.setUdaName(_customerUDAs.get(0).getUdaName());
      newUdaSubType.setUdaValue(customerSubTypeUDAValue);
      udaASIList.add(newUdaSubType);

      // UDA "Customer Information" -> "Customer ID Type"
      Uda newUdaCustomerIDType = asiServices.getNewUda();
      newUdaCustomerIDType.setGroupName(_customerUDAs.get(1).getUdaGroup());
      newUdaCustomerIDType.setUdaName(_customerUDAs.get(1).getUdaName());
      newUdaCustomerIDType.setUdaValue(idTypeUDAValue);
      udaASIList.add(newUdaCustomerIDType);

      // UDA "Customer Information" -> "Account Number"
      Uda newUdaAccountNo = asiServices.getNewUda();
      newUdaAccountNo.setGroupName(_customerUDAs.get(2).getUdaGroup());
      newUdaAccountNo.setUdaName(_customerUDAs.get(2).getUdaName());
      newUdaAccountNo.setUdaValue(accountNoUDAValue);
      udaASIList.add(newUdaAccountNo);

      LockService lockService = asiServices.getLockService();
      lockService.lock(customer.getCustomerKey());
      customerService.update(customer);
      lockService.unlock(customer.getCustomerKey());

      customerKey = Mapper_DTO_To_Pojo.mapToKeyPojo(insertedCustomerKey);

      _log.info("New Customer created with CustomerID " + customerId + "; custInstId = " + insertedCustomerKey.getInstId());
    }
    else {
      _log.info("Failed to create new Customer with CustomerID " + customerId);
    }


    return customerKey;
  }

  public KeyPojo getCustomerKeyByCustomerId(String customerId) throws Exception {
    KeyPojo customerKey = null;

    Customer customer = getCustomerById(customerId);
    if(customer != null) {
      customerKey = Mapper_DTO_To_Pojo.mapToKeyPojo(customer.getCustomerKey());
    }

    return customerKey;
  }

  private Customer getCustomerById(String customerId) throws Exception {
    Customer foundCustomer = null;

    AsiServices asiServices = AsiServices.getInstance();
    CustomerService customerService = asiServices.getCustomerService();

    Customer customer = asiServices.getNewCustomer();
    customer.setCustomerId(customerId);

    Query query = new Query();
    query.addQueryEntry(customer);

    DataObject[] queryResult = customerService.query(query);
    if (queryResult != null && queryResult.length > 0) {
      if(queryResult.length > 1) {
        throw new Exception("Too many customer with id " + customerId + " found: " + queryResult.length);
      }
      foundCustomer = (Customer)queryResult[0];
    }

    return foundCustomer;
  }

  private Customer getCustomerByInstId(long custInstId) throws Exception {
    Customer foundCustomer;

    AsiServices asiServices = AsiServices.getInstance();
    CustomerService customerService = asiServices.getCustomerService();

    foundCustomer = (Customer)customerService.get(new CustomerKey(custInstId));

    return foundCustomer;
  }

  private class CustomerUDAInfo {
    private String _udaName;
    private String _udaGroup;

    CustomerUDAInfo(String udaGroup, String udaName) {
      _udaGroup = udaGroup;
      _udaName = udaName;
    }

    String getUdaName() {
      return _udaName;
    }

    String getUdaGroup() {
      return _udaGroup;
    }
  }

}
