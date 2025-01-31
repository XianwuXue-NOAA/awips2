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
package com.raytheon.uf.edex.plugin.ffmp;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.Executor;
import java.util.regex.Pattern;

import com.raytheon.edex.plugin.radar.dao.RadarStationDao;
import com.raytheon.edex.site.SiteUtil;
import com.raytheon.edex.urifilter.URIFilter;
import com.raytheon.edex.urifilter.URIGenerateMessage;
import com.raytheon.uf.common.dataplugin.PluginException;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPAggregateRecord;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPBasinData;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPBasinMetaData;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPDataContainer;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPGuidanceInterpolation;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPRecord;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPTemplates;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPTemplates.MODE;
import com.raytheon.uf.common.dataplugin.ffmp.FFMPUtils;
import com.raytheon.uf.common.dataplugin.ffmp.SourceBinList;
import com.raytheon.uf.common.dataplugin.message.DataURINotificationMessage;
import com.raytheon.uf.common.dataplugin.radar.RadarStation;
import com.raytheon.uf.common.dataplugin.radar.util.RadarsInUseUtil;
import com.raytheon.uf.common.datastorage.DataStoreFactory;
import com.raytheon.uf.common.datastorage.IDataStore;
import com.raytheon.uf.common.datastorage.IDataStore.StoreOp;
import com.raytheon.uf.common.datastorage.Request;
import com.raytheon.uf.common.datastorage.StorageProperties;
import com.raytheon.uf.common.datastorage.StorageProperties.Compression;
import com.raytheon.uf.common.datastorage.records.ByteDataRecord;
import com.raytheon.uf.common.datastorage.records.IDataRecord;
import com.raytheon.uf.common.event.EventBus;
import com.raytheon.uf.common.localization.ILocalizationFile;
import com.raytheon.uf.common.localization.IPathManager;
import com.raytheon.uf.common.localization.LocalizationContext;
import com.raytheon.uf.common.localization.LocalizationContext.LocalizationLevel;
import com.raytheon.uf.common.localization.LocalizationContext.LocalizationType;
import com.raytheon.uf.common.localization.LocalizationFile;
import com.raytheon.uf.common.localization.PathManagerFactory;
import com.raytheon.uf.common.monitor.config.FFMPRunConfigurationManager;
import com.raytheon.uf.common.monitor.config.FFMPSourceConfigurationManager;
import com.raytheon.uf.common.monitor.config.FFMPSourceConfigurationManager.DATA_TYPE;
import com.raytheon.uf.common.monitor.config.FFMPSourceConfigurationManager.GUIDANCE_TYPE;
import com.raytheon.uf.common.monitor.config.FFMPSourceConfigurationManager.SOURCE_TYPE;
import com.raytheon.uf.common.monitor.config.FFMPTemplateConfigurationManager;
import com.raytheon.uf.common.monitor.events.MonitorConfigEvent;
import com.raytheon.uf.common.monitor.events.MonitorConfigListener;
import com.raytheon.uf.common.monitor.xml.DomainXML;
import com.raytheon.uf.common.monitor.xml.FFMPRunXML;
import com.raytheon.uf.common.monitor.xml.FFTIAttributeXML.ATTRIBUTE;
import com.raytheon.uf.common.monitor.xml.FFTISourceXML;
import com.raytheon.uf.common.monitor.xml.ProductRunXML;
import com.raytheon.uf.common.monitor.xml.ProductXML;
import com.raytheon.uf.common.monitor.xml.SourceIngestConfigXML;
import com.raytheon.uf.common.monitor.xml.SourceXML;
import com.raytheon.uf.common.serialization.SerializationException;
import com.raytheon.uf.common.serialization.SerializationUtil;
import com.raytheon.uf.common.stats.ProcessEvent;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;
import com.raytheon.uf.common.time.util.TimeUtil;
import com.raytheon.uf.common.util.FileUtil;
import com.raytheon.uf.edex.core.EDEXUtil;
import com.raytheon.uf.edex.core.EdexException;
import com.raytheon.uf.edex.core.dataplugin.PluginRegistry;
import com.raytheon.uf.edex.cpgsrv.CompositeProductGenerator;
import com.raytheon.uf.edex.dat.utils.DatMenuUtil;
import com.raytheon.uf.edex.database.DataAccessLayerException;
import com.raytheon.uf.edex.database.cluster.ClusterLockUtils;
import com.raytheon.uf.edex.database.cluster.ClusterLockUtils.LockState;
import com.raytheon.uf.edex.database.cluster.ClusterTask;
import com.raytheon.uf.edex.plugin.ffmp.common.FFMPConfig;
import com.raytheon.uf.edex.plugin.ffmp.common.FFMPProcessor;
import com.raytheon.uf.edex.plugin.ffmp.common.FFTI;
import com.raytheon.uf.edex.plugin.ffmp.common.FFTIAccum;
import com.raytheon.uf.edex.plugin.ffmp.common.FFTIData;
import com.raytheon.uf.edex.plugin.ffmp.common.FFTIProcessor;
import com.raytheon.uf.edex.plugin.ffmp.common.FFTIRatioDiff;

/**
 *
 * Generates FFMP Data records
 *
 * <pre>
 * SOFTWARE HISTORY
 *
 * Date          Ticket#  Engineer     Description
 * ------------- -------- ------------ -----------------------------------------
 * Jun 21, 2009  2521     dhladky      Initial Creation.
 * Feb 03, 2011  6500     cjeanbap     Fixed NullPointerException.
 * Jul 31, 2011  578      dhladky      FFTI modifications
 * Jan 27, 2013  1478     dhladky      Added creation of full cache records to
 *                                     help read write stress on NAS
 * Feb 01, 2013  1569     dhladky      Added constants, switched to using
 *                                     aggregate records written through pypies
 * Feb 20, 2013  1635     dhladky      Added some finally methods to increase
 *                                     dead lock safety.  Reduced wait times for
 *                                     threads.
 * Feb 25, 2013  1660     dhladky      Redesigned data flow for FFTI in order to
 *                                     have only one mosaic piece in memory at a
 *                                     time.
 * Mar 13, 2013  1478     dhladky      non-FFTI mosaic containers weren't
 *                                     getting ejected.  Made it so that they
 *                                     are ejected after processing as well.
 * Mar 22, 2013  1803     dhladky      Fixed broken performance logging for
 *                                     ffmp.
 * Jul 03, 2013  2131     dhladky      InitialLoad array was forcing total FDC
 *                                     re-query with every update.
 * Jul 15, 2013  2184     dhladky      Remove all HUC's for storage except ALL
 * Aug 30, 2013  2298     rjpeter      Make getPluginName abstract
 * Apr 24, 2014  2940     dhladky      Prevent storage of bad records.
 * Jul 10, 2014  2914     garmendariz  Remove EnvProperties
 * Aug 26, 2014  3503     bclement     removed constructDataURI() call
 * Aug 08, 2015  4722     dhladky      Generalized the processing of FFMP data
 *                                     types.
 * Sep 09, 2015  4756     dhladky      Further generalization of FFG processing.
 * Sep 21, 2015  4756     dhladky      Allow ARCHIVE types to not be purged out.
 * Nov 12, 2015  4834     njensen      Changed LocalizationOpFailedException to
 *                                     LocalizationException
 * Jan 27, 2016  5237     tgurney      Replace deprecated LocalizationFile
 *                                     method calls
 * Mar 02, 2016  5432     bkowal       Updates due to method deprecation.
 * Aug 09, 2016  5819     mapeters     FFTI and source files moved from SITE to
 *                                     CONFIGURED
 * Jun 15, 2017  5570     tgurney      Send PDOs to separate route for persist
 *
 * </pre>
 *
 * @author dhladky
 */

public class FFMPGenerator extends CompositeProductGenerator
        implements MonitorConfigListener {

    private static final IUFStatusHandler statusHandler = UFStatus
            .getHandler(FFMPGenerator.class);

    /**
     * Public constructor for FFMPGenerator
     *
     * @param executor
     */
    public FFMPGenerator(Executor executor) {

        super(genName, productType, executor);
    }

    private static final String genName = "FFMP";

    private static final String templateTaskName = "FFMP Template";

    private static final String productType = "ffmp";

    /**
     * The thought was this will eventually be dynamic when front end can
     * support it.
     */
    public static final int SOURCE_CACHE_TIME = 6;

    /**
     * The thought was this will eventually be dynamic, static in AWIPS I. This
     * is the time back limit for Flash Flood Guidance sources
     */
    public static final int FFG_SOURCE_CACHE_TIME = 24;

    /** ArrayList of domains to filter for */
    private ArrayList<DomainXML> domains = null;

    /** template loader bool **/
    public boolean loaded = false;

    /** check ffg first time you run **/
    public boolean ffgCheck = false;

    /** ffti finished processing **/
    public boolean fftiDone = true;

    /** Processes map <dataKey, SourceXML> **/
    private ConcurrentHashMap<String, SourceXML> processes = null;

    /** array list of sources to evaluate **/
    public ArrayList<FFTISourceXML> fftiSources = new ArrayList<>();

    /** run configuration manager **/
    public FFMPRunConfigurationManager frcm = null;

    /** source configuration manager **/
    public FFMPSourceConfigurationManager fscm = null;

    /** temp cache **/
    private ConcurrentMap<String, FFMPDataContainer> ffmpData = new ConcurrentHashMap<>();

    /** FFTI accum/ratio/diff cache **/
    public ConcurrentHashMap<String, FFTIData> fftiData = new ConcurrentHashMap<>();

    /** template config manager **/
    public FFMPTemplateConfigurationManager tempConfig = null;

    /** FFMPConfig object **/
    public FFMPConfig config = null;

    /** template **/
    public FFMPTemplates template = null;

    private IPathManager pathManager;

    @Override
    protected void configureFilters() {

        this.pathManager = PathManagerFactory.getPathManager();

        statusHandler.handle(Priority.INFO,
                getGeneratorName() + " process Filter Config...");
        domains = new ArrayList<>();
        boolean configValid = getRunConfig().isPopulated();

        if (configValid) {
            for (FFMPRunXML run : getRunConfig().getFFMPRunners()) {
                domains = run.getDomains();
            }
        } else {

            /**
             * Don't have one, so create an EDEX generated default
             */
            LocalizationContext commonStaticSite = pathManager.getContext(
                    LocalizationType.COMMON_STATIC, LocalizationLevel.SITE);

            List<String> sites = RadarsInUseUtil.getSite(null,
                    RadarsInUseUtil.LOCAL_CONSTANT);

            FFMPRunXML runner = new FFMPRunXML();
            ArrayList<ProductRunXML> products = new ArrayList<>();
            // these two are always there in default setups
            ProductRunXML hpeProduct = new ProductRunXML();
            hpeProduct.setProductName("DHRMOSAIC");
            hpeProduct.setProductKey("hpe");
            products.add(hpeProduct);

            ProductRunXML biasHpeProduct = new ProductRunXML();
            biasHpeProduct.setProductName("BDHRMOSAIC");
            biasHpeProduct.setProductKey("bhpe");
            products.add(biasHpeProduct);

            ArrayList<String> rfc = new ArrayList<>();

            if (sites.isEmpty()) {
                RadarStationDao dao = new RadarStationDao();
                List<RadarStation> stations = null;
                try {
                    stations = dao.queryByWfo(SiteUtil.getSite());
                } catch (DataAccessLayerException e) {
                    statusHandler.handle(Priority.ERROR,
                            "Unable to access data object for radar station table",
                            e);
                }

                for (RadarStation station : stations) {
                    // this is just for a default
                    ProductRunXML dhrProduct = new ProductRunXML();
                    dhrProduct.setProductName("DHR");
                    dhrProduct.setProductKey(station.getRdaId().toLowerCase());
                    products.add(dhrProduct);

                    String newRfc = FFMPUtils
                            .getRFC(dhrProduct.getProductKey());
                    if (!rfc.contains(newRfc)) {
                        rfc.add(newRfc);
                    }

                    sites.add(station.getRdaId().toLowerCase());
                }

            } else {
                for (String site : sites) {
                    // this is just for a default
                    ProductRunXML dhrProduct = new ProductRunXML();
                    dhrProduct.setProductName("DHR");
                    dhrProduct.setProductKey(site);
                    products.add(dhrProduct);

                    String newRfc = FFMPUtils
                            .getRFC(dhrProduct.getProductKey());
                    if (!rfc.contains(newRfc)) {
                        rfc.add(newRfc);
                    }
                }
            }

            runner.setProducts(products);

            // Apply site list to all QPE types
            for (String source : getSourceConfig().getQPESources()) {
                SourceXML qpeSource = getSourceConfig().getSource(source);
                // Radar Derived sources use the primary source site keys for
                // mosiac datakey
                // Auto Config for any Radar derived sources
                if (qpeSource.getDataType()
                        .equals(DATA_TYPE.RADAR.getDataType())) {
                    SourceIngestConfigXML sicm = new SourceIngestConfigXML();
                    sicm.setSourceName(qpeSource.getSourceName());
                    sicm.setUriSubLocation(3);

                    for (String siteid : sites) {
                        sicm.addDataKey(siteid);
                    }

                    runner.addSourceIngest(sicm);
                }
            }

            // We have a list of available RFC's, now find mosaic
            // Apply this to all RFCFFG sources
            for (String source : getSourceConfig().getGuidances()) {
                SourceXML guidSource = getSourceConfig().getSource(source);

                // Auto config for RFC sources
                if (guidSource.isRfc()) {
                    // add a source mosaic config to the Run Config
                    SourceIngestConfigXML sicm = new SourceIngestConfigXML();
                    sicm.setSourceName(guidSource.getSourceName());
                    sicm.setUriSubLocation(3);

                    for (String dataKey : rfc) {
                        sicm.addDataKey(dataKey);
                    }

                    runner.addSourceIngest(sicm);
                }
            }

            // Apply site list to all SCANQPF default
            for (String source : getSourceConfig().getQPFSources()) {
                SourceXML qpfSource = getSourceConfig().getSource(source);
                // Radar Derived sources use the primary source site keys for
                // mosiac datakey
                // Auto Config for any Radar derived sources (QPFSCAN) for
                // example
                if ("QPFSCAN".equals(qpfSource.getSourceName())) {
                    SourceIngestConfigXML sicm = new SourceIngestConfigXML();
                    sicm.setSourceName(qpfSource.getSourceName());
                    sicm.setUriSubLocation(3);

                    for (String siteid : sites) {
                        sicm.addDataKey(siteid);
                    }

                    runner.addSourceIngest(sicm);
                }
            }

            DomainXML domain = new DomainXML();
            domain.setPrimary(true);
            domain.setCwa(commonStaticSite.getContextName());
            runner.addDomain(domain);

            getRunConfig().addFFMPRunner(runner);
            getRunConfig().saveConfigXml();
            getRunConfig().setPopulated(true);

            domains.add(domain);
        }

        // kick off template generation
        this.getExecutor().execute(new TemplateLoader(domains));
    }

    @Override
    protected void createFilters() {
        // do more here if you wish

        ArrayList<FFMPRunXML> runners = getRunConfig().getFFMPRunners();
        ArrayList<FFMPURIFilter> tmp = new ArrayList<>(runners.size());

        for (FFMPRunXML runner : runners) {
            DomainXML domain = runner.getPrimaryDomain();
            try {
                tmp.add(new FFMPURIFilter(getSiteString(runner) + ":"
                        + getGuidanceComparedString(runner) + ":"
                        + domain.getCwa()));

                statusHandler.handle(Priority.INFO, "Created FFMP Filter.."
                        + " primary Domain: " + domain.getCwa());
            } catch (Exception e) {
                statusHandler.handle(Priority.PROBLEM,
                        "Couldn't create FFMP Filter.." + " primary Domain: "
                                + domain.getCwa()
                                + " this RUNNER is not a viable FFMP config.",
                        e);
            }
        }

        filters = tmp.toArray(new URIFilter[tmp.size()]);

    }

    /**
     * Slight difference in the way ffmp operates as opposed to the URIFilter in
     * general.
     */
    @Override
    public void matchURIs(DataURINotificationMessage messages) {
        URIFilter[] filters = getFilters();
        if (filters != null) {
            for (URIFilter filter2 : filters) {
                if (filter2 != null) {
                    FFMPURIFilter filter = (FFMPURIFilter) filter2;

                    if (loaded) {

                        synchronized (filter) {

                            if (filter.isMatched(messages)) {
                                // does this filter use RFC FFG?
                                if (filter.rfc != null) {
                                    if (!ffgCheck) {

                                        filter = getFFG(filter);
                                        filter.setValidTime(
                                                filter.getCurrentTime());
                                        ffgCheck = true;
                                    }
                                }

                                dispatch(filter);
                            }
                        }
                    } else {
                        statusHandler.info(getGeneratorName()
                                + ": templates not loaded yet. Skipping product");
                    }
                }
            }
        }
    }

    @Override
    public void generateProduct(URIGenerateMessage genMessage) {
        if (loaded) {
            try {
                long time = System.currentTimeMillis();
                this.config = new FFMPConfig(
                        (FFMPURIGenerateMessage) genMessage, this);
                processes = new ConcurrentHashMap<>();
                // read config updates, make sure we don't miss something
                getRunConfig().readConfigXml();
                getSourceConfig().readConfigXml();

                if (config.getSources() != null) {
                    for (String source : config.getSources().keySet()) {
                        processes.put(source,
                                getSourceConfig().getSource(source));
                    }
                }

                // start threads
                for (SourceXML sourceXml : processes.values()) {
                    this.getExecutor()
                            .execute(new ProcessProduct(sourceXml, this));
                }

                // count down latch
                while (!processes.isEmpty()) {
                    // wait for all threads to finish before returning
                    try {
                        Thread.sleep(50);
                        if (statusHandler.isPriorityEnabled(Priority.DEBUG)) {
                            statusHandler.handle(Priority.DEBUG,
                                    "Checking status ..." + processes.size());
                            for (String source : processes.keySet()) {
                                statusHandler.handle(Priority.DEBUG,
                                        "Still processing ..." + source);
                            }
                        }
                    } catch (InterruptedException e) {
                        statusHandler.handle(Priority.ERROR,
                                "Process thread had been interupted!", e);
                    }
                }

                if (!fftiSources.isEmpty()) {
                    this.getExecutor().execute(new FFTI(this));
                }

                while (!fftiSources.isEmpty()) {
                    try {
                        Thread.sleep(50);
                        if (statusHandler.isPriorityEnabled(Priority.DEBUG)) {
                            statusHandler.handle(Priority.DEBUG,
                                    "Checking status ..." + fftiDone);
                        }
                    } catch (InterruptedException e) {
                        statusHandler.handle(Priority.DEBUG,
                                "Checking status failed!" + e);
                    }
                }

                statusHandler.handle(Priority.INFO,
                        config.getCWA() + " finished, duration: "
                                + (System.currentTimeMillis() - time) + " ms ");

                ffmpData.clear();
                // suggest garbage collection
                System.gc();

            } catch (Throwable e) {
                statusHandler.handle(Priority.ERROR,
                        "Unable to process FFMP Records.", e);
            }
        }
    }

    /**
     * Get the list of domains
     *
     * @return
     */
    public ArrayList<DomainXML> getDomains() {
        return domains;
    }

    /**
     * Add a filtering CWA
     *
     * @param domain
     */
    public void addDomain(DomainXML domain) {
        domains.add(domain);
    }

    @Override
    public boolean isRunning() {
        return getConfigManager().getFFMPState();
    }

    /**
     * Set list of CWA's
     *
     * @param domains
     */
    public void setDomains(ArrayList<DomainXML> domains) {
        this.domains = domains;
    }

    /**
     * Inner class to thread the ffmp processing
     *
     * @author dhladky
     *
     */
    private class ProcessProduct implements Runnable {

        private final SourceXML ffmpProduct;

        private final FFMPGenerator generator;

        @Override
        public void run() {
            try {
                if (statusHandler.isPriorityEnabled(Priority.DEBUG)) {
                    statusHandler.handle(Priority.DEBUG,
                            "ProcessProduct: Starting thread "
                                    + ffmpProduct.getSourceName());
                }
                process();
                if (statusHandler.isPriorityEnabled(Priority.DEBUG)) {
                    statusHandler.handle(Priority.DEBUG,
                            "ProcessProduct: Finishing thread "
                                    + ffmpProduct.getSourceName());
                }
            } catch (Exception e) {
                statusHandler.handle(Priority.ERROR, "ProcessProduct: removed "
                        + ffmpProduct.getSourceName(), e);
            } finally {
                processes.remove(ffmpProduct.getSourceName());
            }
        }

        public ProcessProduct(SourceXML ffmpProduct, FFMPGenerator generator) {
            this.ffmpProduct = ffmpProduct;
            this.generator = generator;
        }

        /**
         * The actual work gets done here
         */
        public void process() throws Exception {

            HashMap<String, Object> dataHash = config
                    .getSourceData(ffmpProduct.getSourceName());

            FFMPRunXML runner = getRunConfig().getRunner(config.getCWA());

            // process all of the dataKeys for this source
            for (String dataKey : dataHash.keySet()) {

                ArrayList<String> sites = new ArrayList<>();

                // is it a mosaic?
                if (ffmpProduct.isMosaic()) {

                    // Take care of defaults, all in this case
                    for (ProductRunXML product : runner.getProducts()) {
                        // no duplicate keys!
                        if (!sites.contains(product.getProductKey())) {
                            sites.add(product.getProductKey());
                        }
                    }

                    // do filtering
                    for (ProductRunXML product : runner.getProducts()) {
                        // includes
                        if (product.hasIncludes()) {
                            for (String includeSourceName : product
                                    .getIncludes()) {
                                if (ffmpProduct.getSourceName()
                                        .equals(includeSourceName)) {
                                    // no duplicate keys!
                                    if (!sites.contains(
                                            product.getProductKey())) {
                                        sites.add(product.getProductKey());
                                    }
                                }
                            }
                        }
                        // excludes
                        if (product.hasExcludes()) {
                            for (String excludeSourceName : product
                                    .getExcludes()) {
                                if (ffmpProduct.getSourceName()
                                        .equals(excludeSourceName)) {
                                    sites.remove(product.getProductKey());
                                }
                            }
                        }
                    }
                } else {
                    // No mosaic, just individual site run
                    String siteKey = dataKey;

                    // special case for XMRG's
                    if (ffmpProduct.getDataType()
                            .equals(FFMPSourceConfigurationManager.DATA_TYPE.XMRG
                                    .getDataType())) {

                        siteKey = null;
                        String primarySource = null;

                        for (ProductXML product : getSourceConfig()
                                .getProducts()) {
                            if (product.containsSource(
                                    ffmpProduct.getSourceName())) {
                                primarySource = product.getPrimarySource();
                                break;
                            }
                        }

                        for (ProductRunXML productRun : runner.getProducts()) {
                            if (productRun.getProductName()
                                    .equals(primarySource)) {
                                siteKey = productRun.getProductKey();
                                break;
                            }
                        }
                    }

                    sites.add(siteKey);
                }

                // Go over all of the sites, if mosaic source, can be many.
                for (String siteKey : sites) {

                    // No dataKey hash?, dataKey comes from primary source
                    // (siteKey)
                    if (dataKey == null) {
                        dataKey = siteKey;
                    }

                    FFMPRecord ffmpRec = new FFMPRecord();
                    ffmpRec.setSourceName(ffmpProduct.getSourceName());
                    ffmpRec.setDataKey(dataKey);
                    ffmpRec.setSiteKey(siteKey);
                    ffmpRec.setWfo(config.getCWA());
                    FFMPProcessor ffmp = new FFMPProcessor(config, generator,
                            ffmpRec, template);
                    ffmpRec = ffmp.processFFMP(ffmpProduct);

                    if (ffmpRec != null) {

                        persistRecord(ffmpRec);
                        processDataContainer(ffmpRec, siteKey);
                        // Now that we have the data container,
                        // we can process FFTI for this piece of the mosaic

                        if (ffmp.isFFTI()) {

                            fftiDone = false;
                            FFTISourceXML fftiSource = ffmp.getFFTISource();

                            // This only runs once for the site key loop
                            if (!fftiSources.contains(fftiSource)) {
                                FFTIProcessor ffti = new FFTIProcessor(
                                        generator, ffmpRec,
                                        ffmp.getFFTISource());
                                fftiSources.add(ffmp.getFFTISource());
                                ffti.processFFTI();
                            }

                            // Do the accumulation now, more memory efficient.
                            // Only one piece in memory at a time
                            for (String attribute : ffmp.getAttributes()) {
                                if (attribute.equals(
                                        ATTRIBUTE.ACCUM.getAttribute())) {
                                    FFTIAccum accum = getAccumulationForSite(
                                            ffmpProduct.getDisplayName(),
                                            siteKey, dataKey,
                                            fftiSource.getDurationHour(),
                                            ffmpProduct.getUnit(siteKey));
                                    if (statusHandler.isPriorityEnabled(
                                            Priority.DEBUG)) {
                                        statusHandler
                                                .debug("Accumulating FFTI for source: "
                                                        + ffmpProduct
                                                                .getDisplayName()
                                                        + " site: " + siteKey
                                                        + " data: " + dataKey
                                                        + " duration: "
                                                        + fftiSource
                                                                .getDurationHour()
                                                        + " accumulation: "
                                                        + accum.getAccumulation());
                                    }
                                }
                            }
                        }

                        SourceXML source = getSourceConfig()
                                .getSource(ffmpRec.getSourceName());

                        if (!source.getSourceType()
                                .equals(SOURCE_TYPE.GUIDANCE.getSourceType())) {
                            String sourceSiteDataKey = getSourceSiteDataKey(
                                    source, dataKey, ffmpRec);
                            ffmpData.remove(sourceSiteDataKey);
                        }
                    }
                }
            }
        }
    }

    /**
     * Inner class to background template creation
     *
     * @author dhladky
     *
     */
    private class TemplateLoader implements Runnable {

        private final ArrayList<DomainXML> templateDomains;

        private DomainXML primaryDomain;

        @Override
        public void run() {
            statusHandler.handle(Priority.DEBUG,
                    getGeneratorName() + " Start loader ");

            for (DomainXML domain : templateDomains) {
                if (domain.isPrimary()) {
                    primaryDomain = domain;
                }
            }

            // generate templates and unify geometries
            loaded = load();
            statusHandler.handle(Priority.DEBUG,
                    getGeneratorName() + " Finishing loader ");
        }

        public TemplateLoader(ArrayList<DomainXML> templateDomains) {
            this.templateDomains = templateDomains;
        }

        /**
         *
         * @param domain
         */
        public void createUnifiedGeometries(DomainXML domain) {
            ArrayList<String> hucsToGen = new ArrayList<>();
            hucsToGen.add(FFMPRecord.ALL);
            hucsToGen.add(FFMPRecord.COUNTY);

            for (int i = template.getTotalHucLevels() - 1; i >= 0; i--) {
                hucsToGen.add("HUC" + i);
            }

            for (String huc : hucsToGen) {
                template.verifyUnifiedGeometries(huc, domain.getCwa());
            }
        }

        public boolean load() {
            // load / create primary domain
            ClusterTask task = null;
            String lockDetails = getGeneratorName() + ":"
                    + primaryDomain.getCwa() + ":" + primaryDomain.getCwa();
            try {
                do {
                    task = ClusterLockUtils.lock(templateTaskName, lockDetails,
                            600 * 1000, true);
                } while (task.getLockState() != LockState.SUCCESSFUL);

                template = FFMPTemplates.getInstance(primaryDomain, MODE.EDEX);
                // setup the config
                getTemplateConfig();
                createUnifiedGeometries(primaryDomain);
            } finally {
                if (task != null
                        && task.getLockState() == LockState.SUCCESSFUL) {
                    ClusterLockUtils.unlock(task, false);
                }
            }

            // load the secondary domains
            List<DomainXML> domainsToGen = new ArrayList<>(templateDomains);
            while (!domainsToGen.isEmpty()) {
                Iterator<DomainXML> iter = domainsToGen.iterator();
                boolean processedDomain = false;
                while (iter.hasNext()) {
                    DomainXML domain = iter.next();
                    lockDetails = getGeneratorName() + ":"
                            + primaryDomain.getCwa() + ":" + domain.getCwa();
                    try {
                        task = ClusterLockUtils.lock(templateTaskName,
                                lockDetails, 300 * 1000, false);

                        if (task.getLockState() == LockState.SUCCESSFUL) {
                            template.addDomain(domain);
                            createUnifiedGeometries(domain);
                            iter.remove();
                            processedDomain = true;
                        }
                    } finally {
                        if (task != null && task
                                .getLockState() == LockState.SUCCESSFUL) {
                            ClusterLockUtils.unlock(task, false);
                        }
                    }
                }

                if (!processedDomain) {
                    // Didn't process a domain, locked by another cluster
                    // member, sleep and try again
                    try {
                        Thread.sleep(50);
                    } catch (InterruptedException e) {
                        statusHandler.handle(Priority.WARN,
                                "Domain processing Interrupted!", e);
                    }
                }
            }

            return template.done;
        }
    }

    /**
     * Gets the string buffer for the Guidance sources you wish to compare in
     * FFMP
     *
     * @param run
     * @return
     */
    private String getGuidanceComparedString(FFMPRunXML run) {
        StringBuilder sb = new StringBuilder();

        for (SourceIngestConfigXML ingest : run.getSourceIngests()) {
            SourceXML source = FFMPSourceConfigurationManager.getInstance()
                    .getSource(ingest.getSourceName());
            if (source.isRfc()) {
                int i = 0;
                for (String dataKey : ingest.getDataKey()) {
                    if (i < ingest.getDataKey().size() - 1) {
                        sb.append(dataKey).append(",");
                    } else {
                        sb.append(dataKey);
                    }
                    i++;
                }
                break;
            }
            // TODO: Implement other types when available
        }
        return sb.toString();
    }

    /**
     * Gets the string buffer for the domain site definition.
     *
     * @param run
     * @return
     */
    private String getSiteString(FFMPRunXML run) {
        String sites = null;
        StringBuilder sb = new StringBuilder();
        for (ProductRunXML product : run.getProducts()) {
            SourceXML source = getSourceConfig()
                    .getSource(product.getProductName());
            // XMRG types have a different ingest route for FFMP
            if (!source.getDataType().equals(DATA_TYPE.XMRG.getDataType())) {
                sb.append(product.getProductKey()).append(",");
            }
        }
        sites = sb.toString();
        if (sites.endsWith(",")) {
            sites = sites.substring(0, sites.length() - 1);
        }
        return sites;
    }

    /**
     * Write your new SourceBins
     *
     * @param sourceList
     */
    public void writeSourceBins(SourceBinList sourceList) {

        try {
            LocalizationContext lc = pathManager.getContext(
                    LocalizationType.COMMON_STATIC,
                    LocalizationLevel.CONFIGURED);

            LocalizationFile lflist = pathManager.getLocalizationFile(lc,
                    getAbsoluteSourceFileName(sourceList.getSourceId()));

            FileUtil.bytes2File(SerializationUtil.transformToThrift(sourceList),
                    lflist.getFile(), true);

            lflist.save();

            statusHandler.handle(Priority.INFO,
                    "Wrote FFMP source Bin File: " + sourceList.getSourceId());

        } catch (Exception e) {
            statusHandler.error("Error writing FFMP source bin file for source "
                    + sourceList.getSourceId(), e);
        }
    }

    /**
     * Read out your SourceBins
     *
     * @param sourceId
     * @return
     */
    public SourceBinList readSourceBins(String sourceId) {

        SourceBinList sbl = null;
        LocalizationContext lc = pathManager.getContext(
                LocalizationType.COMMON_STATIC, LocalizationLevel.CONFIGURED);
        LocalizationFile f = pathManager.getLocalizationFile(lc,
                getAbsoluteSourceFileName(sourceId));

        try {
            sbl = SerializationUtil.transformFromThrift(SourceBinList.class,
                    FileUtil.readCompressedFileAsBytes(f.getFile()));
        } catch (FileNotFoundException e) {
            statusHandler.handle(Priority.ERROR,
                    "Unable to locate file " + f.getPath(), e);
        } catch (SerializationException e) {
            statusHandler.handle(Priority.ERROR,
                    "Unable to read file " + f.getPath(), e);
        } catch (IOException e) {
            statusHandler.handle(Priority.ERROR,
                    "General IO problem with file " + f.getPath(), e);
        }

        return sbl;
    }

    /**
     * Gets the completed filename
     *
     * @return
     */
    public String getAbsoluteSourceFileName(String sourceId) {
        return productType + IPathManager.SEPARATOR + "sources"
                + IPathManager.SEPARATOR + sourceId + ".bin";
    }

    /**
     * See if you have one
     *
     * @param sourceId
     * @return
     */
    public boolean isExistingSourceBin(String sourceId) {
        LocalizationContext lc = pathManager.getContext(
                LocalizationType.COMMON_STATIC, LocalizationLevel.CONFIGURED);
        ILocalizationFile f = pathManager.getLocalizationFile(lc,
                getAbsoluteSourceFileName(sourceId));
        return f.exists();
    }

    /**
     * Gets the list of bins for that source
     *
     * @param sourceId
     * @return
     */
    public SourceBinList getSourceBinList(String sourceId) {
        return readSourceBins(sourceId);
    }

    /**
     * Sets the source bins, first time
     *
     * @param sbl
     */
    public void setSourceBinList(SourceBinList sbl) {
        writeSourceBins(sbl);
    }

    /**
     * Do pull strategy on FFG data, currently works with Gridded FFG sources
     * only. (There are only gridded sources so far)
     *
     * @param filter
     * @return
     */
    private FFMPURIFilter getFFG(FFMPURIFilter filter) {

        ArrayList<String> uris = new ArrayList<>();

        // Check RFC types
        for (String rfc : filter.getRFC()) {
            // get a hash of the sources and their grib ids
            Set<String> sources = FFMPUtils.getFFGParameters(rfc);
            if (sources != null && !sources.isEmpty()) {
                for (String source : sources) {

                    try {
                        SourceXML sourceXml = getSourceConfig()
                                .getSource(source);

                        if (sourceXml != null) {

                            String plugin = getSourceConfig().getSource(source)
                                    .getPlugin();
                            uris.add(FFMPUtils.getFFGDataURI(GUIDANCE_TYPE.RFC,
                                    rfc, source, plugin));
                        }
                    } catch (Exception e) {
                        statusHandler
                                .error("Problem with extracting guidance source URI's. source="
                                        + source, e);
                    }
                }
            }
        }

        // Check for ARCHIVE types
        ArrayList<String> guidSources = getSourceConfig().getGuidances();
        if (guidSources != null && !guidSources.isEmpty()) {
            for (String guidSource : guidSources) {

                try {
                    SourceXML sourceXml = getSourceConfig()
                            .getSource(guidSource);

                    if (sourceXml != null && sourceXml.getGuidanceType() != null
                            && sourceXml.getGuidanceType().equals(
                                    GUIDANCE_TYPE.ARCHIVE.getGuidanceType())) {
                        String plugin = sourceXml.getPlugin();
                        String[] uriComps = FFMPUtils
                                .parseGridDataPath(sourceXml.getDataPath());
                        /*
                         * datasetid is UriComp[3], parameter abbreviation is
                         * UriComp[7]
                         */
                        uris.add(FFMPUtils.getFFGDataURI(GUIDANCE_TYPE.ARCHIVE,
                                uriComps[3], uriComps[7], plugin));
                    }
                } catch (Exception e) {
                    statusHandler
                            .error("Problem with extracting guidance source URI's. source: "
                                    + guidSource, e);
                }
            }
        }

        // treat it like a regular uri in the filter.
        if (!uris.isEmpty()) {
            for (String dataUri : uris) {
                // add your pattern checks to the key
                for (Pattern pattern : filter.getMatchURIs().keySet()) {
                    /*
                     * Safety, eliminates chance of unattached source config
                     * uri's coming in that have no pattern attached to them.
                     */
                    if (dataUri != null && pattern != null) {
                        statusHandler.handle(Priority.INFO, "Pattern: "
                                + pattern.toString() + " Key: " + dataUri);
                        try {
                            if (pattern.matcher(dataUri).find()) {
                                // matches one of them, which one?
                                String matchKey = filter
                                        .getPatternName(pattern);
                                /*
                                 * put the sourceName:dataPath key into the
                                 * sources array list.
                                 */
                                filter.getSources().put(matchKey, dataUri);
                            }
                        } catch (Exception e) {
                            statusHandler.handle(Priority.ERROR,
                                    "Unable to locate new FFG file. " + dataUri,
                                    e);
                        }
                    }
                }
            }
        }

        return filter;
    }

    /**
     * get the FFMP data container for this source
     *
     * @param siteSourceKey
     * @param backDate
     *
     * @return
     */

    public FFMPDataContainer getFFMPDataContainer(String siteSourceKey,
            Date backDate) {

        FFMPDataContainer container = ffmpData.get(siteSourceKey);

        if (container == null) {

            String siteKey = null;

            String[] parts = siteSourceKey.split("-");

            if (parts.length > 1) {
                siteKey = parts[0];
            }

            container = loadFFMPDataContainer(siteSourceKey, siteKey,
                    config.getCWA(), backDate);

            if (container != null) {
                ffmpData.put(siteSourceKey, container);
            }
        }

        return container;
    }

    /*
     * Gets the FFTI sources to be run
     */
    public ArrayList<FFTISourceXML> getFFTISources() {
        return fftiSources;
    }

    /**
     * source config manager
     *
     * @return
     */
    public FFMPSourceConfigurationManager getSourceConfig() {
        if (fscm == null) {
            fscm = FFMPSourceConfigurationManager.getInstance();
            fscm.addListener(this);
        }
        return fscm;
    }

    /**
     * run config manager
     *
     * @return
     */
    public FFMPRunConfigurationManager getRunConfig() {
        if (frcm == null) {
            frcm = FFMPRunConfigurationManager.getInstance();
            frcm.addListener(this);
        }
        return frcm;
    }

    /**
     * Template config manager
     *
     * @return
     */
    public FFMPTemplateConfigurationManager getTemplateConfig() {
        if (tempConfig == null) {
            tempConfig = FFMPTemplateConfigurationManager.getInstance();
            tempConfig.addListener(this);
        }
        return tempConfig;
    }

    /**
     * dispatch a filter for processing
     *
     * @param filter
     */
    private void dispatch(FFMPURIFilter filter) {

        try {
            EDEXUtil.getMessageProducer().sendAsync(routeId, SerializationUtil
                    .transformToThrift(filter.createGenerateMessage()));
        } catch (Exception e) {
            statusHandler
                    .handle(Priority.ERROR,
                            getGeneratorName() + ": filter: " + filter.getName()
                                    + ": failed to route filter to generator",
                            e);
        } finally {
            // safer, this way filter never gets set in weird state
            filter.setValidTime(new Date(System.currentTimeMillis()));
            filter.reset();
        }
    }

    /**
     * Process the ffmp data container
     *
     * @param ffmpRec
     * @param productKey
     */
    public void processDataContainer(FFMPRecord ffmpRec, String productKey) {

        String sourceName = null;
        Date backDate = null;
        String sourceSiteDataKey = null;
        FFMPDataContainer fdc = null;
        boolean write = true;

        try {
            // write out the fast loader cache file
            long ptime = System.currentTimeMillis();
            SourceXML source = getSourceConfig()
                    .getSource(ffmpRec.getSourceName());
            String dataKey = ffmpRec.getDataKey();

            if (source.getSourceType()
                    .equals(SOURCE_TYPE.GUIDANCE.getSourceType())) {
                sourceName = source.getDisplayName();
                sourceSiteDataKey = sourceName;
                /**
                 * Some FFG is ARCHIVE, don't purge, backdate == refTime The
                 * reset (RFCFFG) set to refTime - 1 day.
                 */
                if (source.getGuidanceType()
                        .equals(GUIDANCE_TYPE.ARCHIVE.getGuidanceType())) {
                    /**
                     * ARCHIVE types have the refTime of when it was loaded.
                     * This will have it look back 1 day previous to the reftime
                     * and purge anything older than that.
                     */
                    backDate = new Date(ffmpRec.getDataTime().getRefTime()
                            .getTime()
                            - TimeUtil.MILLIS_PER_HOUR * FFG_SOURCE_CACHE_TIME);
                } else {
                    backDate = new Date(config.getDate().getTime()
                            - TimeUtil.MILLIS_PER_HOUR * FFG_SOURCE_CACHE_TIME);
                }
            } else {
                sourceName = ffmpRec.getSourceName();
                sourceSiteDataKey = sourceName + "-" + ffmpRec.getSiteKey()
                        + "-" + dataKey;
                backDate = new Date(ffmpRec.getDataTime().getRefTime().getTime()
                        - TimeUtil.MILLIS_PER_HOUR * SOURCE_CACHE_TIME);
            }

            // pull from disk if there
            fdc = getFFMPDataContainer(sourceSiteDataKey, backDate);

            // brand new or initial load up
            if (fdc == null) {

                long time = System.currentTimeMillis();
                fdc = new FFMPDataContainer(sourceSiteDataKey);
                fdc = FFTIProcessor.populateDataContainer(fdc, template,
                        backDate, ffmpRec.getDataTime().getRefTime(),
                        ffmpRec.getWfo(), source, ffmpRec.getSiteKey());

                long time2 = System.currentTimeMillis();
                statusHandler.handle(Priority.DEBUG, "Populated new source: in "
                        + (time2 - time) + " ms: source: " + sourceSiteDataKey);

            } else {

                long time = System.currentTimeMillis();
                // guidance sources are treated as a mosaic and are handled
                // differently. They are force read at startup.
                // This is the main line sequence a source will take when
                // updated.
                if (!source.getSourceType()
                        .equals(SOURCE_TYPE.GUIDANCE.getSourceType())) {

                    Date newDate = fdc.getNewest();
                    Date oldDate = fdc.getOldest();

                    if (newDate != null && oldDate != null) {
                        if (ffmpRec.getDataTime().getRefTime().getTime()
                                - newDate.getTime() >= source
                                        .getExpirationMinutes(
                                                ffmpRec.getSiteKey())
                                        * TimeUtil.MILLIS_PER_MINUTE) {
                            // force a re-query back to the newest time in
                            // existing source container, this will fill in
                            // gaps
                            // if
                            // they exist.
                            fdc = FFTIProcessor.populateDataContainer(fdc,
                                    template, newDate,
                                    ffmpRec.getDataTime().getRefTime(),
                                    ffmpRec.getWfo(), source,
                                    ffmpRec.getSiteKey());

                        } else if (oldDate.after(new Date(backDate.getTime()
                                - source.getExpirationMinutes(
                                        ffmpRec.getSiteKey())
                                        * TimeUtil.MILLIS_PER_MINUTE))) {
                            // force a re-query back to barrierTime for
                            // existing source container, this happens if
                            // the
                            // ingest was turned off for some period of
                            // time.
                            fdc = FFTIProcessor.populateDataContainer(fdc,
                                    template, backDate, oldDate,
                                    ffmpRec.getWfo(), source,
                                    ffmpRec.getSiteKey());
                        }
                    }

                    long time2 = System.currentTimeMillis();
                    statusHandler.handle(Priority.DEBUG,
                            "Checked Source files: in " + (time2 - time)
                                    + " ms: source: " + sourceSiteDataKey);
                }
            }

            // add current record data

            fdc.addFFMPEntry(ffmpRec.getDataTime().getRefTime(), source,
                    ffmpRec.getBasinData(), ffmpRec.getSiteKey());

            // cache it temporarily for FFTI use
            if (source.getSourceType()
                    .equals(SOURCE_TYPE.GUIDANCE.getSourceType())) {
                // only write last one
                write = false;

                if (!ffmpData.containsKey(sourceSiteDataKey)) {
                    ffmpData.put(sourceSiteDataKey, fdc);
                } else {
                    ffmpData.replace(sourceSiteDataKey, fdc);
                }
            }

            statusHandler.handle(Priority.INFO,
                    "Processed FFMPDataContainer: in "
                            + (System.currentTimeMillis() - ptime)
                            + " ms: source: " + sourceSiteDataKey);
        } catch (Exception e) {
            statusHandler.handle(Priority.ERROR,
                    "Failed Processing FFMPDataContainer " + e.getMessage(), e);

        } finally {
            // purge it up
            if (fdc != null) {
                // this is defensive for if errors get thrown
                if (backDate == null) {
                    backDate = new Date(System.currentTimeMillis()
                            - TimeUtil.MILLIS_PER_HOUR * SOURCE_CACHE_TIME);
                }

                if (!fdc.isPurged()) {
                    fdc.purge(backDate);
                }

                if (write) {
                    // write it out
                    writeAggregateRecord(fdc, sourceSiteDataKey);
                }
            }
        }
    }

    /**
     * load existing container
     *
     * @param sourceSiteDataKey
     * @param siteKey
     * @param wfo
     * @param backDate
     * @return
     */
    public FFMPDataContainer loadFFMPDataContainer(String sourceSiteDataKey,
            String siteKey, String wfo, Date backDate) {

        FFMPDataContainer fdc = null;
        FFMPAggregateRecord record = null;
        boolean populated = false;

        try {
            record = readAggregateRecord(sourceSiteDataKey, wfo);
        } catch (Exception e) {
            // this isn't necessarily an error
            statusHandler.handle(Priority.DEBUG,
                    "Couldn't load source file: " + sourceSiteDataKey, e);
        }

        // condition for first time read in
        if (fdc == null && record != null) {
            // creates a place holder for this source
            fdc = new FFMPDataContainer(sourceSiteDataKey, record);
            populated = true;
        }

        // condition for update to fdc while in use
        if (record != null && !populated) {
            fdc.setAggregateData(record);
        }

        /**
         * sometimes a record will sit around for a long time and it will have
         * data going back to the last precip event this can be an enormous
         * amount of time. Want to get the data dumped from memory ASAP.
         */
        if (fdc != null && backDate != null) {
            fdc.purge(backDate);
        }

        return fdc;
    }

    /**
     * Load existing aggregate record
     *
     * @param sourceSiteDataKey
     * @param wfo
     * @return
     * @throws IOException
     */
    private FFMPAggregateRecord readAggregateRecord(String sourceSiteDataKey,
            String wfo) throws Exception {

        FFMPAggregateRecord record = null;

        File hdf5File = FFMPUtils.getHdf5File(wfo, sourceSiteDataKey);
        IDataStore dataStore = DataStoreFactory.getDataStore(hdf5File);
        IDataRecord rec = dataStore.retrieve(wfo, sourceSiteDataKey,
                Request.ALL);
        byte[] bytes = ((ByteDataRecord) rec).getByteData();
        record = SerializationUtil
                .transformFromThrift(FFMPAggregateRecord.class, bytes);

        return record;
    }

    /**
     * Writes the aggregate FFMP records
     *
     * @param fdc
     */
    public void writeAggregateRecord(FFMPDataContainer fdc,
            String sourceSiteDataKey) {

        WriteAggregateRecord writer = new WriteAggregateRecord(fdc,
                sourceSiteDataKey);
        writer.run();
    }

    /**
     * Inner class to thread writing aggregate records
     *
     * @author dhladky
     *
     */
    private class WriteAggregateRecord implements Runnable {

        private final FFMPDataContainer fdc;

        private final String sourceSiteDataKey;

        @Override
        public void run() {
            try {
                write();
            } catch (Exception e) {
                statusHandler.handle(Priority.ERROR,
                        "WriteAggregateRecord: removed " + e.getMessage(), e);
            }
        }

        public WriteAggregateRecord(FFMPDataContainer fdc,
                String sourceSiteDataKey) {
            this.fdc = fdc;
            this.sourceSiteDataKey = sourceSiteDataKey;
            statusHandler.handle(Priority.DEBUG,
                    "Created Aggregate Record Writer");
        }

        /**
         * The actual work gets done here
         */
        public void write() {
            try {

                FFMPAggregateRecord aggRecord = null;

                synchronized (fdc) {

                    aggRecord = new FFMPAggregateRecord();
                    aggRecord.setSourceSiteDataKey(sourceSiteDataKey);
                    aggRecord.setWfo(config.getCWA());
                    // times for Guidance basins will be null
                    aggRecord.setTimes(fdc.getOrderedTimes());
                    fdc.getBasinData().serialize();
                    aggRecord.setBasins(fdc.getBasinData());
                }

                if (aggRecord.getBasins() != null) {

                    try {

                        StorageProperties sp = null;
                        String compression = PluginRegistry.getInstance()
                                .getRegisteredObject(productType)
                                .getCompression();
                        if (compression != null) {
                            sp = new StorageProperties();
                            sp.setCompression(Compression.valueOf(compression));
                        }

                        byte[] bytes = SerializationUtil
                                .transformToThrift(aggRecord);

                        // NAME | GROUP | array |Dimension | size
                        IDataRecord rec = new ByteDataRecord(sourceSiteDataKey,
                                config.getCWA(), bytes, 1,
                                new long[] { bytes.length });

                        File hdf5File = FFMPUtils.getHdf5File(config.getCWA(),
                                sourceSiteDataKey);
                        IDataStore dataStore = DataStoreFactory
                                .getDataStore(hdf5File);
                        // write it, allowing, and in fact encouraging replacing
                        // the last one
                        dataStore.addDataRecord(rec, sp);
                        dataStore.store(StoreOp.REPLACE);

                    } catch (Exception e) {
                        statusHandler.handle(Priority.ERROR,
                                "General Error Writing aggregate record", e);
                    }
                }

            } catch (Exception e) {
                statusHandler.handle(Priority.ERROR,
                        "Error writing aggregate record", e);
            }
        }
    }

    @Override
    public synchronized void configChanged(MonitorConfigEvent fce) {

        boolean reload = false;

        if (fce.getSource() instanceof FFMPTemplateConfigurationManager) {
            statusHandler.handle(Priority.INFO,
                    "Re-configuring FFMP & URI filters...Template Config change");
            reload = true;
            FFMPTemplateConfigurationManager ftcm = (FFMPTemplateConfigurationManager) fce
                    .getSource();
            if (ftcm.isRegenerate()) {
                template.dumpTemplates();
            }

            tempConfig = null;

        } else if (fce.getSource() instanceof FFMPRunConfigurationManager) {
            statusHandler.handle(Priority.INFO,
                    "Re-configuring FFMP & URI filters...Run Config change");
            reload = true;
            frcm = null;
        }

        else if (fce.getSource() instanceof FFMPSourceConfigurationManager) {
            statusHandler.handle(Priority.INFO,
                    "Re-configuring FFMP & URI filters...Source Config change");
            reload = true;
            fscm = null;
        }

        if (reload) {

            ffgCheck = false;
            resetFilters();

            if (ffmpData != null) {
                ffmpData.clear();
            }
            if (fftiData != null) {
                fftiData.clear();
            }

            DatMenuUtil dmu = new DatMenuUtil();
            dmu.setDatSite(SiteUtil.getSite());
            dmu.setOverride(true);
            dmu.createMenus();
        }
    }

    /**
     * FFTI data cache
     *
     * @param ffti
     */
    public void writeFFTIData(String fftiName, FFTIData ffti) {
        if (fftiData.containsKey(fftiName)) {
            fftiData.replace(fftiName, ffti);
        } else {
            fftiData.put(fftiName, ffti);
        }

        writeFFTIFile(ffti, fftiName);
    }

    /**
     * Get FFTI data cache
     *
     * @param fftiName
     * @return
     */
    public FFTIData getFFTIData(String fftiName) {
        // preserve the state of the reset value
        boolean reset = true;
        if (fftiData.containsKey(fftiName)) {
            reset = fftiData.get(fftiName).isReset();
        }

        FFTIData ffti = readFFTIData(fftiName);

        if (fftiData != null) {
            ffti.setReset(reset);
            fftiData.put(fftiName, ffti);
        }
        return ffti;
    }

    /**
     * Write your FFTI Data files
     *
     * @param ffti
     * @param fftiName
     */
    public void writeFFTIFile(FFTIData ffti, String fftiName) {

        try {
            LocalizationContext lc = pathManager.getContext(
                    LocalizationType.COMMON_STATIC,
                    LocalizationLevel.CONFIGURED);

            LocalizationFile lflist = pathManager.getLocalizationFile(lc,
                    getAbsoluteFFTIFileName(fftiName));

            FileUtil.bytes2File(SerializationUtil.transformToThrift(ffti),
                    lflist.getFile(), true);

            lflist.save();

            statusHandler.handle(Priority.DEBUG,
                    "Wrote FFMP FFTI file: " + fftiName);

        } catch (Exception e) {
            statusHandler.error("Error writing FFTI file " + fftiName, e);
        }
    }

    /**
     * Read out your FFTI Files
     *
     * @param fftiName
     * @return
     */
    public FFTIData readFFTIData(String fftiName) {

        FFTIData ffti = null;
        LocalizationContext lc = pathManager.getContext(
                LocalizationType.COMMON_STATIC, LocalizationLevel.CONFIGURED);
        LocalizationFile f = pathManager.getLocalizationFile(lc,
                getAbsoluteFFTIFileName(fftiName));

        try {
            ffti = SerializationUtil.transformFromThrift(FFTIData.class,
                    FileUtil.readCompressedFileAsBytes(f.getFile()));
        } catch (FileNotFoundException fnfe) {
            statusHandler.handle(Priority.ERROR,
                    "Unable to locate file " + f.getPath(), fnfe);
        } catch (SerializationException se) {
            statusHandler.handle(Priority.ERROR,
                    "Unable to serialize file " + f.getPath(), se);
        } catch (IOException ioe) {
            statusHandler.handle(Priority.ERROR,
                    "IO problem reading file " + f.getPath(), ioe);
        } catch (Exception e) {
            statusHandler.handle(Priority.ERROR,
                    "General Exception reading file " + f.getPath(), e);
        }

        return ffti;
    }

    /**
     * Gets the completed filename
     *
     * @return
     */
    public String getAbsoluteFFTIFileName(String fftiName) {
        return productType + IPathManager.SEPARATOR + "ffti"
                + IPathManager.SEPARATOR + fftiName + ".bin";
    }

    /**
     * See if you have one
     *
     * @param fftiName
     * @return
     */
    public boolean isFFTI(String fftiName) {
        LocalizationContext lc = pathManager.getContext(
                LocalizationType.COMMON_STATIC, LocalizationLevel.CONFIGURED);
        ILocalizationFile f = pathManager.getLocalizationFile(lc,
                getAbsoluteFFTIFileName(fftiName));
        boolean exists = false;
        if (f != null) {
            exists = f.exists();
        }

        return exists;
    }

    /**
     * get the whole container
     *
     * @return
     */
    public ConcurrentHashMap<String, FFTIData> getFFTIDataContainer() {
        return fftiData;
    }

    /**
     * Get value for an individual piece of the puzzle
     *
     * @param fftiSourceKey
     * @param fftiSiteKey
     * @param fftiDataKey
     * @param duration
     * @param unit
     * @return
     */
    public FFTIAccum getAccumulationForSite(String fftiSourceKey,
            String fftiSiteKey, String fftiDataKey, double duration,
            String unit) {

        SourceXML ffmpSource = getSourceConfig()
                .getSourceByDisplayName(fftiSourceKey);
        FFTIAccum accumulator = null;
        String siteDataKey = ffmpSource.getDisplayName() + "-" + fftiSiteKey
                + "-" + fftiDataKey;

        if (isFFTI(siteDataKey)) {
            accumulator = (FFTIAccum) getFFTIData(siteDataKey);
        } else {
            accumulator = new FFTIAccum();
        }

        // This will only happen at initial load, update, and duration changes.
        if (accumulator.isReset() || accumulator.getDuration() != duration) {

            accumulator.setDuration(duration);
            accumulator.setUnit(unit);

            if (ffmpSource.isMosaic()) {
                accumulator.setName(ffmpSource.getDisplayName());
            } else {
                accumulator.setName(fftiSiteKey + "-" + fftiSourceKey);
            }

            long cur = config.getDate().getTime();
            long timeBack = (long) (duration * TimeUtil.MILLIS_PER_HOUR);
            Date backDate = new Date(cur - timeBack);
            long expirationTime = ffmpSource.getExpirationMinutes(fftiSiteKey)
                    * TimeUtil.MILLIS_PER_MINUTE;

            FFMPDataContainer fdc = null;

            fdc = getFFMPDataContainer(siteDataKey, backDate);

            if (fdc != null) {

                FFMPBasinData fbd = fdc.getBasinData();

                // go over the list of CWAs gathering the pfaf list
                ArrayList<Long> pfafs = new ArrayList<>();
                ArrayList<String> cwaList = config.fdm.getCwaList();

                Double gap = FFTI.getGap(fdc, ffmpSource, config.getDate(),
                        duration, fftiSiteKey);

                if (!Double.isNaN(gap)) {
                    for (Long key : fbd.getBasins().keySet()) {
                        for (String cwa : cwaList) {

                            boolean primary = false;
                            if (cwa.equals(config.getCWA())) {
                                primary = true;
                            }

                            FFMPBasinMetaData fmdb = template
                                    .getBasin(fftiSiteKey, key);

                            if (fmdb == null) {
                                continue;
                            }

                            // Gets buffer zones adjacent to CWA
                            if (cwa.equals(fmdb.getCwa())
                                    || primary && fmdb.isPrimaryCwa()) {
                                if (!pfafs.contains(key)) {
                                    pfafs.add(key);
                                }
                            }
                        }
                    }

                    double amount = fdc.getMaxValue(pfafs, backDate,
                            config.getDate(), expirationTime,
                            ffmpSource.isRate());

                    // max value for monitored area
                    accumulator.setAccumulation(amount);
                    accumulator.setGap(gap);
                }
            }

            ffmpData.remove(siteDataKey);
            accumulator.setReset(false);
            writeFFTIData(siteDataKey, accumulator);
        }

        return accumulator;
    }

    /**
     * Gets the ratio and difference values for this site
     *
     * @param qSourceKey
     * @param qSiteKey
     * @param ffgType
     * @param duration
     * @param unit
     * @return
     */
    public FFTIRatioDiff getRatioAndDiffForSite(String qSourceKey,
            String qSiteKey, String ffgType, double duration, String unit) {

        FFTIRatioDiff values = null;
        SourceXML ffmpQSource = fscm.getSourceByDisplayName(qSourceKey);

        if (ffmpQSource == null) {
            ffmpQSource = fscm.getSource(qSourceKey);
        }

        String siteDataKey = ffgType + "-" + ffmpQSource.getSourceName() + "-"
                + qSiteKey;

        if (isFFTI(siteDataKey)) {
            values = (FFTIRatioDiff) getFFTIData(siteDataKey);
            if (values.getGuids() == null || values.getQpes() == null) {
                values.setReset(true);
            }
        } else {
            values = new FFTIRatioDiff();
        }

        // This will only happen at initial load, update, and duration changes.
        if (values.isReset() || values.getDuration() != duration) {

            values.setDuration(duration);
            values.setUnit(unit);

            long cur = config.getDate().getTime();
            long timeBack = (long) (duration * TimeUtil.MILLIS_PER_HOUR);
            Date backDate = new Date(cur - timeBack);
            long expirationTime = ffmpQSource.getExpirationMinutes(qSiteKey)
                    * TimeUtil.MILLIS_PER_MINUTE;

            // make sure we have data
            Date ffgBackDate = new Date(
                    config.getDate().getTime() - TimeUtil.MILLIS_PER_HOUR
                            * FFMPGenerator.FFG_SOURCE_CACHE_TIME);

            String primarySource = fscm.getPrimarySource(ffmpQSource);
            ProductXML product = fscm.getProduct(primarySource);

            FFMPDataContainer guidContainer = getFFMPDataContainer(ffgType,
                    ffgBackDate);

            long guidSourceExpiration = 0l;

            if (guidContainer == null) {
                guidContainer = new FFMPDataContainer(ffgType);
            }

            for (SourceXML iguidSource : product
                    .getGuidanceSourcesByType(ffgType)) {

                if (guidSourceExpiration == 0l) {
                    guidSourceExpiration = iguidSource.getExpirationMinutes(
                            qSiteKey) * TimeUtil.MILLIS_PER_MINUTE;
                    break;
                }
            }

            // if still nothing, punt!
            if (guidContainer.size() == 0) {

                statusHandler.handle(Priority.PROBLEM,
                        "FFTI: No guidance sources available for " + qSiteKey
                                + " " + qSourceKey + " " + " comparison.");
                return values;
            }

            String qpeSiteSourceDataKey = ffmpQSource.getSourceName() + "-"
                    + qSiteKey + "-" + qSiteKey;
            FFMPDataContainer qpeContainer = getFFMPDataContainer(
                    qpeSiteSourceDataKey, backDate);

            if (qpeContainer != null) {
                // go over the list of CWAs gathering the pfaf list
                ArrayList<Long> pfafs = new ArrayList<>();
                ArrayList<String> cwaList = config.fdm.getCwaList();
                FFMPBasinData fbd = qpeContainer.getBasinData();

                for (Long key : fbd.getBasins().keySet()) {
                    for (String cwa : cwaList) {

                        boolean primary = false;
                        if (cwa.equals(config.getCWA())) {
                            primary = true;
                        }

                        FFMPBasinMetaData fmdb = template.getBasin(qSiteKey,
                                key);

                        if (fmdb == null) {
                            continue;
                        }

                        // Gets buffer zones adjacent to CWA
                        if (cwa.equals(fmdb.getCwa())
                                || primary && fmdb.isPrimaryCwa()) {
                            if (!pfafs.contains(key)) {
                                pfafs.add(key);
                            }
                        }
                    }
                }

                Double gap = FFTI.getGap(qpeContainer, ffmpQSource,
                        config.getDate(), duration, qSiteKey);

                if (!Double.isNaN(gap)) {

                    List<Float> qpes = qpeContainer.getBasinData()
                            .getAccumValues(pfafs, backDate, config.getDate(),
                                    expirationTime, false);

                    FFMPGuidanceInterpolation interpolator = new FFMPGuidanceInterpolation(
                            fscm, product,
                            frcm.getRunner(config.getCWA())
                                    .getProduct(qSiteKey),
                            primarySource, ffgType, qSiteKey);
                    interpolator.setInterpolationSources(duration);

                    List<Float> guids = guidContainer.getBasinData()
                            .getGuidanceValues(pfafs, interpolator,
                                    guidSourceExpiration);

                    values.setQpes(qpes);
                    values.setGuids(guids);
                    values.setGap(gap);
                }
            } else {
                return values;
            }

            // replace or insert it
            ffmpData.remove(qpeSiteSourceDataKey);
            values.setReset(false);
            writeFFTIData(siteDataKey, values);
        }

        return values;
    }

    /**
     * Persist the record that has finished processing. This is different than
     * other DAT tools. Other tools wait until all are finished processing
     * before persisting. FFMP persists as it goes in order to lessen the data
     * surge being sent to pypies.
     *
     * @param record
     */
    private synchronized void persistRecord(FFMPRecord record) {

        // persist out this record
        try {
            FFMPRecord[] records = new FFMPRecord[] { record };
            // manually persist
            EDEXUtil.checkPersistenceTimes(records);
            new FFMPDao(getCompositeProductType(), template, fscm,
                    config.getCWA()).persistRecords(records);
            EDEXUtil.getMessageProducer().sendSync("ffmpStageNotification",
                    records);
            // clear out pdos that are written
            pdos = null;
        } catch (PluginException | EdexException e) {
            statusHandler.handle(Priority.PROBLEM,
                    "Couldn't persist the record.", e);
        }

    }

    /**
     * Find siteSourceDataKey
     *
     * @param source
     * @param dataKey
     * @param ffmpRec
     * @return
     */
    private String getSourceSiteDataKey(SourceXML source, String dataKey,
            FFMPRecord ffmpRec) {

        String sourceName = source.getSourceName();
        String sourceSiteDataKey = null;

        if (source.getSourceType()
                .equals(SOURCE_TYPE.GUIDANCE.getSourceType())) {
            sourceName = source.getDisplayName();
            sourceSiteDataKey = sourceName;

        } else {
            sourceName = ffmpRec.getSourceName();
            sourceSiteDataKey = sourceName + "-" + ffmpRec.getSiteKey() + "-"
                    + dataKey;
        }

        return sourceSiteDataKey;
    }

    /**
     * Log process statistics
     *
     * @param message
     */
    @Override
    public void log(URIGenerateMessage message) {

        long curTime = System.currentTimeMillis();
        ProcessEvent processEvent = new ProcessEvent();

        if (productType != null) {
            processEvent.setDataType(productType);
        }

        Long dequeueTime = message.getDeQueuedTime();
        if (dequeueTime != null) {
            long elapsedMilliseconds = curTime - dequeueTime;
            processEvent.setProcessingTime(elapsedMilliseconds);
        }

        Long enqueueTime = message.getEnQueuedTime();
        if (enqueueTime != null) {
            long latencyMilliseconds = curTime - enqueueTime;
            processEvent.setProcessingLatency(latencyMilliseconds);
        }

        // processing in less than 0 millis isn't trackable, usually due to
        // an
        // error occurred and statement logged incorrectly
        if (processEvent.getProcessingLatency() > 0
                && processEvent.getProcessingTime() > 0) {
            EventBus.publish(processEvent);
        }
    }

}
