/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.uf.edex.plugin.mpe.dao.impl;

import java.util.List;

import com.raytheon.uf.common.dataplugin.shef.tables.Radarresp;
import com.raytheon.uf.edex.plugin.mpe.dao.AbstractIHFSDbDao;

/**
 * IHFS Database Dao for interacting with the {@link Radarresp} entity.
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * May 13, 2016 5576       bkowal      Initial creation
 * May 19, 2016 5576       bkowal      Made constructor public
 * 
 * </pre>
 * 
 * @author bkowal
 */

public class RadarrespDao extends AbstractIHFSDbDao<Radarresp, String> {

    public RadarrespDao() {
        super(Radarresp.class);
    }

    public List<Radarresp> getForSiteId(final String siteId) {
        return findByNamedQueryAndNamedParam(Radarresp.SELECT_BY_SITE_ID,
                "siteId", siteId);
    }
}