package com.ericsson.stc.c2f_association.graniteService.pojo;

import java.sql.Date;

public class GisDataPojo {
    private String copperPlateId;
    private String fiberPlateId;

    private String status;
    private String error;
    private Date executionDate;

    public GisDataPojo() {
    }

    public GisDataPojo(String copperPlateId, String fiberPlateId) {
        this.copperPlateId = copperPlateId;
        this.fiberPlateId = fiberPlateId;
    }

    public String getCopperPlateId() {
        return copperPlateId;
    }

    public void setCopperPlateId(String copperPlateId) {
        this.copperPlateId = copperPlateId;
    }

    public String getFiberPlateId() {
        return fiberPlateId;
    }

    public void setFiberPlateId(String fiberPlateId) {
        this.fiberPlateId = fiberPlateId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public Date getExecutionDate() {
        return executionDate;
    }

    public void setExecutionDate(Date executionDate) {
        this.executionDate = executionDate;
    }

    @Override
    public String toString() {
        String s = "c=%s; f=%s";
        if (status != null) {
            s += "; status=" + status;
        }
        if (error != null) {
            s += "; error=" + error;
        }
        if (executionDate != null) {
            s += "; date=" + executionDate;
        }

        return String.format(("GIS{" + s + '}'), copperPlateId, fiberPlateId);
    }
}
