<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\InsiderTaxonomyByUrl.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

/**
 * Determines a taxonomy value based on the Insider content url.
 *
 * Parses the URL through several rules and returns the correct value
 *
 * @MigrateProcessPlugin(
 *   id = "insider_taxonomy_by_url"
 * )
 */
class InsiderTaxonomyByUrl extends ProcessPluginBase {
    /**
     * {@inheritdoc}
     */
    public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
        if (empty($value)) {
            // Skip this item if there's no URL.
            throw new MigrateSkipProcessException();
        }

        $returnType = $this->configuration['return_type'];
        $contentType = $this->configuration['content_type'] ?: "";

        $topic = "";
        $topLevel = "";
        $divisionOffice = "";

        if ($this->startsWith(strtolower($value), "/acquisitions/")) {

            $topic = "Acquisitions";
            $divisionOffice = "Office of Acquisitions (OA)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/about_the_sec/")) {

            $topic = "About the SEC";
            $divisionOffice = "Office of Public Affairs (OPA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/CF/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Division of Corporation Finance (CF)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/chairman/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Chairman";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/dera/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Division of Economic and Risk Analysis (DERA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ebo/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "EDGAR Business Office (EBO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/eeo/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Equal Employment Opportunity (OEEO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/enf/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Division of Enforcement (ENF)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ethics/bulletins/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Ethics Counsel (OEC)";
            $topLevel = "Policies and Forms";

            if ($contentType == "generic") {
                $topic = "Ethics";
            }
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ethics/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Ethics Counsel (OEC)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/foia/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/im/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Division of Investment Management (IM)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oalj/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Administrative Law Judges (ALJ)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oasb/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Advocate for Small Business Capital Formation (OASB)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oca/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Chief Accountant (OCA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ocie/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Compliance Inspections and Examinations (OCIE)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ocoo/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Chief Operating Officer (OCOO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ocr/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Credit Ratings (OCR)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ofm/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Financial Management (OFM)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ofrms/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ogc/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the General Counsel (OGC)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/ohr/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oia/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of International Affairs (OIA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oiad/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Investor Advocate (OIAD)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oiea/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Investor Education and Advocacy (OIEA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oig/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Inspector General (OIG)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oit/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Information Technology (OIT)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/olia/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Legislative and Intergovernmental Affairs (OLIA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oms/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Municipal Securities (OMS)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/omwi/employee-groups/")) {

            $topic = "Groups and Clubs";
            $divisionOffice = "Office of Minority and Women Inclusion (OMWI)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/omwi/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Minority and Women Inclusion (OMWI)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/opa/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Public Affairs (OPA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/org-charts/")) {

            $topic = "Organization Charts";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/org_charts/")) {

            $topic = "Divisions and Offices";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/os/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of the Secretary (OS)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/osi/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/oso/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/hqo/tm/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Division of Trading and Markets (TM)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/aro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Atlanta Regional Office (ARO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/bro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Boston Regional Office (BRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/chro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Chicago Regional Office (CHRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/dro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Denver Regional Office (DRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/fwro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Fort Worth Regional Office (FWRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/laro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Los Angeles Regional Office (LARO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/miro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Miami Regional Office (MIRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/nyro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "New York Regional Office (NYRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/plro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Philadelphia Regional Office (PLRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/sfro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "San Francisco Regional Office (SFRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/divisions_offices/rdo/slro/")) {

            $topic = "Divisions and Offices";
            $divisionOffice = "Salt Lake Regional Office (SLRO)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/drop_down_lists/contact_lists/")) {

            $topic = "Phone Directories and Contact Lists";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/drop_down_lists/phone_book/")) {

            $topic = "Phone Directories and Contact Lists";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/drop_down_lists/quick_links/")) {

            $divisionOffice = "Office of Public Affairs (OPA)";
            $divisionOffice = "";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/forms/internal_forms/")) {

            $topic = "Forms";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/human_resources/")) {

            $topic = "Human Resources";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "My SEC";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/core_materials/")) {

            $topic = "";
            $divisionOffice = "Office of the General Counsel (OGC)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/databases/database_guide/")) {

            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/markets_and_sros/")) {

            $topic = "SROs, Exchanges, and Financial Regulatory Organizations";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/public_documents/")) {

            $topic = "Litigation Releases, Enforcement, and SRO Appeals, Securities Laws and Regulations";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/spotlight_on/")) {

            $topic = "Spotlight on Topics of Current Interest at the SEC";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/company_information/")) {

            $topic = "Company Research Guide";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/the_reference_desk/")) {

            $topic = "Library Services";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/passwords/")) {

            $topic = "Passwords";
            $divisionOffice = "Office of Public Affairs (OPA)";
            $topLevel = "Technology";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/court_rules/")) {

            $topic = "Court Information";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/data_feeds/")) {

            $topic = "Data Feeds";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/filers_and_filings/")) {

            $topic = "Registrant Info";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/hot_topics/")) {

            $topic = "Securities Laws";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/legislative_histories/")) {

            $topic = "Legislative Histories";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/media_sources/")) {

            $topic = "News Media Coverage";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "News";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/monthly-features/")) {

            $topic = "Library Services";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/newspapers/")) {

            $topic = "Online Newspapers";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "News";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/of_historical_interest/")) {

            $topic = "Historical Information";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/of_historical_interest/edgar_status_reports")) {

            $topic = "Historical Information";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/of_historical_interest/sec_employee_news/")) {

            $topic = "Historical Information";
            $divisionOffice = "Office of Strategic Initiatives (OSI)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/knowledge_center/virtual_library/")) {

            $topic = "Library Services";
            $divisionOffice = "EDGAR Business Office (EBO)";
            $topLevel = "Research Resources";
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/admin_regulations/r")) {

            /*
            * -Content Type = SECR
            * -Title = [Title from Rhythmyx/*Parse from title]
            * -*Label = SECR
            * -*Series= [parse from title]
            * -* Number within Series = [parse form title]
            */
            $topic = "SEC Administrative Regulations";
            // *Related OP = [must be manually entered]
            // *Related Documents = [must be manually entered]
            // $divisionOffice = "must be individually assigned";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/admin_regulations/op")) {

            // Content Type = OP
            // Title = [Title from Rhythmyx/*Parse from title]
            // *Label = SECR
            // *Series= [parse from title]
            // * Number within Series = [parse form title]

            $topic = "SEC Operating Procedures";
            // *Related SECR = [must be manually entered]
            // *Related Documents = [must be manually entered]
            // $divisionOffice = "must be individually assigned";
            $topLevel = "Policies and Forms";
            // else if ($this->startsWith(strtolower($value), "/policies_procedures/admin_regulations/!op* or !r*
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/admin_regulations/files/")) {

            $topic = "SEC Operating Procedures";
            // $divisionOffice = "must be individually assigned";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/admin_regulations/or")) {

            $topic = "Policies";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/admin_regulations/")) {

            $topic = "Policies";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/policies/")) {

            $topic = "SEC Operating Procedures";
            $divisionOffice = "";
            $topLevel = "Policies and Forms";

            if ($contentType == "generic") {
                $topic = "Policies";
            }
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/procedures/")) {

            $topic = "Policies";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/policies_procedures/")) {

            $topic = "Policies";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/sec_community/getting_to_work/")) {

            $topic = "Commuting";
            $divisionOffice = ['Office of Human Resources (OHR)', 'Office of Support Operations (OSO)'];
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/sec_community/our_sec/award_winners/")) {

            $topic = "Award Programs";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "My SEC";
        } else if ($this->startsWith(strtolower($value), "/sec_community/our_sec/bike_club/")) {

            $topic = "Bicycle";
            // Group/Club Owner = Bike Club
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/sec_community/our_sec/veterans-committee/")) {

            $topic = "Groups and Clubs";
            // Group/Club Owner = Veterans Committee
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/sec_community/our_sec/")) {

            $topic = "Groups and Clubs";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/sec_community/")) {

            $topic = "Groups and Clubs";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/sec_in_news/")) {

            $topic = "News Media Coverage";
            $divisionOffice = "Office of Public Affairs (OPA)";
            $topLevel = "News";
        } else if ($this->startsWith(strtolower($value), "/the_exchange/")) {

            $topic = "Historical Information";
            $divisionOffice = "Office of Public Affairs (OPA)";
            $topLevel = "SEC Organization";
        } else if ($this->startsWith(strtolower($value), "/sec_community/feds-feed-families/fff-2018/")) {

            $topic = "Agencywide Initiatives";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "News";
        } else if ($this->startsWith(strtolower($value), "/sec_technology/cybersecurity/")) {

            $topic = "Cybersecurity";
            $divisionOffice = "Office of Information Technology (OIT)";
            $topLevel = "Technology";
        } else if ($this->startsWith(strtolower($value), "/sec_technology/privacy-compliance/")) {

            $topic = "Privacy";
            $divisionOffice = "Office of Information Technology (OIT)";
            $topLevel = "Policies and Forms";
        } else if ($this->startsWith(strtolower($value), "/sec_technology/recommind-material/")) {

            $topic = "Recommind";
            $divisionOffice = "Division of Enforcement (ENF)";
            $topLevel = "Technology";
        } else if ($this->startsWith(strtolower($value), "/sec_technology/sec-systems/")) {

            $topic = "Systems and Applications";
            $divisionOffice = "Office of Information Technology (OIT)";
            $topLevel = "Technology";
        } else if ($this->startsWith(strtolower($value), "/sec_technology/tcr-manuals/")) {

            $topic = "Tips, Complaints, and Referrals (TCR) System";
            $divisionOffice = "Division of Economic and Risk Analysis (DERA)";
            $topLevel = "Technology";
        } else if ($this->startsWith(strtolower($value), "/sec_technology/")) {

            $topic = "Technology";
            $divisionOffice = "Office of Information Technology (OIT)";
            $topLevel = "Technology";
        } else if ($this->startsWith(strtolower($value), "/secu_training_more/mandatory-training/")) {

            $topic = "Training - Mandatory";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "My SEC";
        } else if ($this->startsWith(strtolower($value), "/secu_training_more/online-training/")) {

            $topic = "Training";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "My SEC";
        } else if ($this->startsWith(strtolower($value), "/secu_training_more/sec-university/")) {

            $topic = "Training";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "My SEC";
        } else if ($this->startsWith(strtolower($value), "/secu_training_more/")) {

            $topic = "Training";
            $divisionOffice = "Office of Human Resources (OHR)";
            $topLevel = "My SEC";
        } else if ($this->startsWith(strtolower($value), "/support_ops/conf_rooms/")) {

            $topic = "Conference Rooms";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/emergency_info/")) {

            $topic = "Emergencies";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/facilities_services/")) {

            $topic = "Facilities";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/floor_plans/")) {

            $topic = "Floor Plans";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/mail_services/")) {

            $topic = "Mail Operations and Deliveries";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/printing-publishing/")) {

            $topic = "Printing and Graphics";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/security_services/")) {

            $topic = "Security";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/supply_services/")) {

            $topic = "Security";
            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/support_ops/")) {

            $divisionOffice = "Office of Support Operations (OSO)";
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/travel/")) {

            $topic = "Travel";
            $divisionOffice = ['Office of Financial Management (OFM)', 'Office of International Affairs (OIA)'];
            $topLevel = "SEC Workplace";
        } else if ($this->startsWith(strtolower($value), "/whats_happening/at_the_sec/")) {

            $topLevel = "News";
        } else if ($this->startsWith(strtolower($value), "/whats_happening/welcome_new_employees/")) {
            // -Audience = New Employees
            $topic = "Human Resources";
            $divisionOffice = ['Office of Human Resources (OHR)', 'Office of Public Affairs (OPA)'];
            $topLevel = "My SEC";
        }


        $returnValue = "";
        if ($returnType == "topic") {
            $returnValue = $topic;
        }
        if ($returnType == "division_office") {
            $returnValue =  $divisionOffice;
        }
        if ($returnType == "top_level") {
            $returnValue =  $topLevel;
        }
        if (empty($returnValue)) {
            echo ("No return value for URL: " . $value . " Requesting: " . $returnType . "\n");
            //       throw new MigrateSkipProcessException();
        }

        return $returnValue;
    }

    function startsWith($haystack, $needle) {
        $length = strlen($needle);
        return (substr($haystack, 0, $length) === $needle);
    }
}
