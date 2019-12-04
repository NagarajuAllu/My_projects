package com.ericsson.stc.c2f_association;

import com.ericsson.stc.c2f_association.graniteService.GraniteService;
import com.ericsson.stc.c2f_association.graniteService.impl.GraniteServiceImpl;
import org.apache.log4j.Logger;

public class CopperToFiberSiteMappingToolDb {
    private static final Logger LOG = Logger.getLogger(CopperToFiberSiteMappingToolDb.class);

    public static void main(String[] args) {
        CopperToFiberSiteMappingToolDb tool = new CopperToFiberSiteMappingToolDb();

        if (args.length != 0) {
            LOG.error("No input parameters are expected");
            System.exit(-1);
        }

        tool.process();
    }

    private void process() {
        GraniteService graniteService = new GraniteServiceImpl();
        graniteService.processGis();
    }
}
