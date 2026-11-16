-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP TYPE public."ActionTokenType";

CREATE TYPE public."ActionTokenType" AS ENUM (
	'PASSWORD_RESET',
	'EMAIL_VERIFY');

-- DROP TYPE public."AnalyticsEventType";

CREATE TYPE public."AnalyticsEventType" AS ENUM (
	'PAGE_VIEW',
	'PRODUCT_VIEW',
	'SEARCH',
	'ADD_TO_CART',
	'REMOVE_FROM_CART',
	'CHECKOUT_START',
	'CHECKOUT_ABANDON');

-- DROP TYPE public."IncidentCategory";

CREATE TYPE public."IncidentCategory" AS ENUM (
	'SYSTEM_INTEGRITY_ATTACK',
	'UNAUTHORIZED_ACCESS',
	'ILLEGAL_INTERCEPTION',
	'DATA_INTEGRITY_ATTACK',
	'COMPUTER_FRAUD',
	'PERSONAL_DATA_BREACH',
	'PHISHING_IMPERSONATION',
	'CREDENTIAL_ABUSE',
	'OTHER');

-- DROP TYPE public."IncidentEventType";

CREATE TYPE public."IncidentEventType" AS ENUM (
	'CREATED',
	'NOTE',
	'STATUS_CHANGE',
	'AUTHORITY_REPORT',
	'EVIDENCE');

-- DROP TYPE public."IncidentSeverity";

CREATE TYPE public."IncidentSeverity" AS ENUM (
	'LOW',
	'MEDIUM',
	'HIGH',
	'CRITICAL');

-- DROP TYPE public."IncidentStatus";

CREATE TYPE public."IncidentStatus" AS ENUM (
	'OPEN',
	'INVESTIGATING',
	'CONTAINED',
	'RESOLVED',
	'REPORTED',
	'CLOSED');

-- DROP TYPE public."KpiPeriod";

CREATE TYPE public."KpiPeriod" AS ENUM (
	'DAY',
	'MONTH',
	'YEAR');

-- DROP TYPE public."ModelRunStatus";

CREATE TYPE public."ModelRunStatus" AS ENUM (
	'RUNNING',
	'SUCCESS',
	'FAILED');

-- DROP TYPE public."OrderStatus";

CREATE TYPE public."OrderStatus" AS ENUM (
	'PENDING',
	'PAID',
	'PREPARING',
	'SHIPPED',
	'DELIVERED',
	'CANCELLED');

-- DROP TYPE public."PaymentStatus";

CREATE TYPE public."PaymentStatus" AS ENUM (
	'UNPAID',
	'PAID',
	'REFUNDED',
	'FAILED',
	'REFUND_PENDING');

-- DROP TYPE public."PromoStatus";

CREATE TYPE public."PromoStatus" AS ENUM (
	'SENDING',
	'SENT',
	'PARTIAL',
	'FAILED');

-- DROP TYPE public."RecommendationStrategy";

CREATE TYPE public."RecommendationStrategy" AS ENUM (
	'BASKET',
	'ITEM_ITEM',
	'CONTENT');

-- DROP TYPE public."ReturnResolution";

CREATE TYPE public."ReturnResolution" AS ENUM (
	'EXCHANGE',
	'REFUND',
	'REPAIR');

-- DROP TYPE public."ReturnStatus";

CREATE TYPE public."ReturnStatus" AS ENUM (
	'REQUESTED',
	'APPROVED',
	'RECEIVED',
	'RESOLVED',
	'REJECTED');

-- DROP TYPE public."ReturnType";

CREATE TYPE public."ReturnType" AS ENUM (
	'RETRACTO',
	'GARANTIA');

-- DROP TYPE public."RiskSubject";

CREATE TYPE public."RiskSubject" AS ENUM (
	'ORDER',
	'USER');

-- DROP TYPE public."Role";

CREATE TYPE public."Role" AS ENUM (
	'CLIENT',
	'SELLER');

-- DROP TYPE public."ShippingMethod";

CREATE TYPE public."ShippingMethod" AS ENUM (
	'PICKUP',
	'STARKEN',
	'CORREOS_CHILE');

-- DROP TYPE public."StockMovementReason";

CREATE TYPE public."StockMovementReason" AS ENUM (
	'SALE',
	'RESTOCK',
	'CORRECTION_UP',
	'CORRECTION_DOWN',
	'DAMAGED',
	'EXPIRED',
	'RETURNED',
	'INITIAL_LOAD',
	'EXCHANGE');

-- DROP TYPE public."StockMovementType";

CREATE TYPE public."StockMovementType" AS ENUM (
	'IN',
	'OUT');

-- DROP TYPE public."SubscriberStatus";

CREATE TYPE public."SubscriberStatus" AS ENUM (
	'PENDING',
	'CONFIRMED',
	'UNSUBSCRIBED');

-- DROP SEQUENCE public."Order_orderNumber_seq";

CREATE SEQUENCE public."Order_orderNumber_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public."Order_orderNumber_seq" OWNER TO neondb_owner;
GRANT ALL ON SEQUENCE public."Order_orderNumber_seq" TO neondb_owner;

-- DROP SEQUENCE public."ReturnRequest_requestNumber_seq";

CREATE SEQUENCE public."ReturnRequest_requestNumber_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public."ReturnRequest_requestNumber_seq" OWNER TO neondb_owner;
GRANT ALL ON SEQUENCE public."ReturnRequest_requestNumber_seq" TO neondb_owner;

-- DROP SEQUENCE public."SecurityIncident_incidentNumber_seq";

CREATE SEQUENCE public."SecurityIncident_incidentNumber_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public."SecurityIncident_incidentNumber_seq" OWNER TO neondb_owner;
GRANT ALL ON SEQUENCE public."SecurityIncident_incidentNumber_seq" TO neondb_owner;
-- public."ActionToken" definition

-- Drop table

-- DROP TABLE public."ActionToken";

CREATE TABLE public."ActionToken" (
	id text NOT NULL,
	"userId" text NOT NULL,
	"type" public."ActionTokenType" NOT NULL,
	"tokenHash" text NOT NULL,
	"expiresAt" timestamp(3) NOT NULL,
	"usedAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "ActionToken_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "ActionToken_expiresAt_not_null" NOT NULL "expiresAt",
	CONSTRAINT "ActionToken_id_not_null" NOT NULL id,
	CONSTRAINT "ActionToken_pkey" PRIMARY KEY (id),
	CONSTRAINT "ActionToken_tokenHash_not_null" NOT NULL "tokenHash",
	CONSTRAINT "ActionToken_type_not_null" NOT NULL type,
	CONSTRAINT "ActionToken_userId_not_null" NOT NULL "userId"
);
CREATE UNIQUE INDEX "ActionToken_tokenHash_key" ON public."ActionToken" USING btree ("tokenHash");
CREATE INDEX "ActionToken_userId_type_idx" ON public."ActionToken" USING btree ("userId", type);

-- Permissions

ALTER TABLE public."ActionToken" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."ActionToken" TO neondb_owner;


-- public."AnalyticsEvent" definition

-- Drop table

-- DROP TABLE public."AnalyticsEvent";

CREATE TABLE public."AnalyticsEvent" (
	id text NOT NULL,
	"sessionId" text NOT NULL,
	"userId" text NULL,
	"type" public."AnalyticsEventType" NOT NULL,
	"productId" text NULL,
	query text NULL,
	"path" text NULL,
	metadata jsonb NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "AnalyticsEvent_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "AnalyticsEvent_id_not_null" NOT NULL id,
	CONSTRAINT "AnalyticsEvent_pkey" PRIMARY KEY (id),
	CONSTRAINT "AnalyticsEvent_sessionId_not_null" NOT NULL "sessionId",
	CONSTRAINT "AnalyticsEvent_type_not_null" NOT NULL type
);
CREATE INDEX "AnalyticsEvent_productId_createdAt_idx" ON public."AnalyticsEvent" USING btree ("productId", "createdAt");
CREATE INDEX "AnalyticsEvent_sessionId_createdAt_idx" ON public."AnalyticsEvent" USING btree ("sessionId", "createdAt");
CREATE INDEX "AnalyticsEvent_type_createdAt_idx" ON public."AnalyticsEvent" USING btree (type, "createdAt");
CREATE INDEX "AnalyticsEvent_userId_createdAt_idx" ON public."AnalyticsEvent" USING btree ("userId", "createdAt");

-- Permissions

ALTER TABLE public."AnalyticsEvent" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."AnalyticsEvent" TO neondb_owner;


-- public."AuditLog" definition

-- Drop table

-- DROP TABLE public."AuditLog";

CREATE TABLE public."AuditLog" (
	id text NOT NULL,
	"actorId" text NULL,
	"actorRole" text NULL,
	"action" text NOT NULL,
	"targetType" text NULL,
	"targetId" text NULL,
	metadata jsonb NULL,
	ip text NULL,
	"userAgent" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "AuditLog_action_not_null" NOT NULL action,
	CONSTRAINT "AuditLog_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "AuditLog_id_not_null" NOT NULL id,
	CONSTRAINT "AuditLog_pkey" PRIMARY KEY (id)
);
CREATE INDEX "AuditLog_action_idx" ON public."AuditLog" USING btree (action);
CREATE INDEX "AuditLog_actorId_idx" ON public."AuditLog" USING btree ("actorId");
CREATE INDEX "AuditLog_createdAt_idx" ON public."AuditLog" USING btree ("createdAt");

-- Permissions

ALTER TABLE public."AuditLog" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."AuditLog" TO neondb_owner;


-- public."Category" definition

-- Drop table

-- DROP TABLE public."Category";

CREATE TABLE public."Category" (
	id text NOT NULL,
	"name" text NOT NULL,
	slug text NOT NULL,
	description text NULL,
	active bool DEFAULT true NOT NULL,
	"order" int4 DEFAULT 0 NOT NULL,
	"archivedAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	CONSTRAINT "Category_active_not_null" NOT NULL active,
	CONSTRAINT "Category_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "Category_id_not_null" NOT NULL id,
	CONSTRAINT "Category_name_not_null" NOT NULL name,
	CONSTRAINT "Category_order_not_null" NOT NULL "order",
	CONSTRAINT "Category_pkey" PRIMARY KEY (id),
	CONSTRAINT "Category_slug_not_null" NOT NULL slug,
	CONSTRAINT "Category_updatedAt_not_null" NOT NULL "updatedAt"
);
CREATE UNIQUE INDEX "Category_name_key" ON public."Category" USING btree (name);
CREATE UNIQUE INDEX "Category_slug_key" ON public."Category" USING btree (slug);

-- Permissions

ALTER TABLE public."Category" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."Category" TO neondb_owner;


-- public."CustomerSegment" definition

-- Drop table

-- DROP TABLE public."CustomerSegment";

CREATE TABLE public."CustomerSegment" (
	id text NOT NULL,
	"userId" text NOT NULL,
	segment text NOT NULL,
	"rScore" int4 NULL,
	"fScore" int4 NULL,
	"mScore" int4 NULL,
	"clusterId" int4 NULL,
	"modelRunId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "CustomerSegment_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "CustomerSegment_id_not_null" NOT NULL id,
	CONSTRAINT "CustomerSegment_pkey" PRIMARY KEY (id),
	CONSTRAINT "CustomerSegment_segment_not_null" NOT NULL segment,
	CONSTRAINT "CustomerSegment_userId_not_null" NOT NULL "userId"
);
CREATE INDEX "CustomerSegment_segment_idx" ON public."CustomerSegment" USING btree (segment);
CREATE UNIQUE INDEX "CustomerSegment_userId_key" ON public."CustomerSegment" USING btree ("userId");

-- Permissions

ALTER TABLE public."CustomerSegment" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."CustomerSegment" TO neondb_owner;


-- public."DataExportRequest" definition

-- Drop table

-- DROP TABLE public."DataExportRequest";

CREATE TABLE public."DataExportRequest" (
	id text NOT NULL,
	"userId" text NOT NULL,
	"requestedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"completedAt" timestamp(3) NULL,
	"downloadUrl" text NULL,
	"expiresAt" timestamp(3) NULL,
	CONSTRAINT "DataExportRequest_id_not_null" NOT NULL id,
	CONSTRAINT "DataExportRequest_pkey" PRIMARY KEY (id),
	CONSTRAINT "DataExportRequest_requestedAt_not_null" NOT NULL "requestedAt",
	CONSTRAINT "DataExportRequest_userId_not_null" NOT NULL "userId"
);

-- Permissions

ALTER TABLE public."DataExportRequest" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."DataExportRequest" TO neondb_owner;


-- public."DeletionRequest" definition

-- Drop table

-- DROP TABLE public."DeletionRequest";

CREATE TABLE public."DeletionRequest" (
	id text NOT NULL,
	"userId" text NOT NULL,
	"requestedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"scheduledFor" timestamp(3) NOT NULL,
	"executedAt" timestamp(3) NULL,
	reason text NULL,
	CONSTRAINT "DeletionRequest_id_not_null" NOT NULL id,
	CONSTRAINT "DeletionRequest_pkey" PRIMARY KEY (id),
	CONSTRAINT "DeletionRequest_requestedAt_not_null" NOT NULL "requestedAt",
	CONSTRAINT "DeletionRequest_scheduledFor_not_null" NOT NULL "scheduledFor",
	CONSTRAINT "DeletionRequest_userId_not_null" NOT NULL "userId"
);

-- Permissions

ALTER TABLE public."DeletionRequest" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."DeletionRequest" TO neondb_owner;


-- public."KpiSnapshot" definition

-- Drop table

-- DROP TABLE public."KpiSnapshot";

CREATE TABLE public."KpiSnapshot" (
	id text NOT NULL,
	"periodType" public."KpiPeriod" NOT NULL,
	"periodStart" timestamp(3) NOT NULL,
	metric text NOT NULL,
	value float8 NOT NULL,
	dimension text DEFAULT '_all'::text NOT NULL,
	"dimensionId" text DEFAULT '_all'::text NOT NULL,
	"modelRunId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "KpiSnapshot_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "KpiSnapshot_dimensionId_not_null" NOT NULL "dimensionId",
	CONSTRAINT "KpiSnapshot_dimension_not_null" NOT NULL dimension,
	CONSTRAINT "KpiSnapshot_id_not_null" NOT NULL id,
	CONSTRAINT "KpiSnapshot_metric_not_null" NOT NULL metric,
	CONSTRAINT "KpiSnapshot_periodStart_not_null" NOT NULL "periodStart",
	CONSTRAINT "KpiSnapshot_periodType_not_null" NOT NULL "periodType",
	CONSTRAINT "KpiSnapshot_pkey" PRIMARY KEY (id),
	CONSTRAINT "KpiSnapshot_value_not_null" NOT NULL value
);
CREATE INDEX "KpiSnapshot_metric_periodStart_idx" ON public."KpiSnapshot" USING btree (metric, "periodStart");
CREATE UNIQUE INDEX "KpiSnapshot_periodType_periodStart_metric_dimension_dimensi_key" ON public."KpiSnapshot" USING btree ("periodType", "periodStart", metric, dimension, "dimensionId");

-- Permissions

ALTER TABLE public."KpiSnapshot" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."KpiSnapshot" TO neondb_owner;


-- public."ModelRun" definition

-- Drop table

-- DROP TABLE public."ModelRun";

CREATE TABLE public."ModelRun" (
	id text NOT NULL,
	"modelType" text NOT NULL,
	"version" text NOT NULL,
	status public."ModelRunStatus" DEFAULT 'RUNNING'::"ModelRunStatus" NOT NULL,
	"rowsIn" int4 NULL,
	metrics jsonb NULL,
	"startedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"finishedAt" timestamp(3) NULL,
	notes text NULL,
	CONSTRAINT "ModelRun_id_not_null" NOT NULL id,
	CONSTRAINT "ModelRun_modelType_not_null" NOT NULL "modelType",
	CONSTRAINT "ModelRun_pkey" PRIMARY KEY (id),
	CONSTRAINT "ModelRun_startedAt_not_null" NOT NULL "startedAt",
	CONSTRAINT "ModelRun_status_not_null" NOT NULL status,
	CONSTRAINT "ModelRun_version_not_null" NOT NULL version
);
CREATE INDEX "ModelRun_modelType_startedAt_idx" ON public."ModelRun" USING btree ("modelType", "startedAt");

-- Permissions

ALTER TABLE public."ModelRun" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."ModelRun" TO neondb_owner;


-- public."NewsletterSubscriber" definition

-- Drop table

-- DROP TABLE public."NewsletterSubscriber";

CREATE TABLE public."NewsletterSubscriber" (
	id text NOT NULL,
	email text NOT NULL,
	status public."SubscriberStatus" DEFAULT 'PENDING'::"SubscriberStatus" NOT NULL,
	"consentVersion" text NOT NULL,
	"consentAt" timestamp(3) NOT NULL,
	"consentIp" text NULL,
	"confirmationSentAt" timestamp(3) NULL,
	"confirmedAt" timestamp(3) NULL,
	"unsubscribedAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	CONSTRAINT "NewsletterSubscriber_consentAt_not_null" NOT NULL "consentAt",
	CONSTRAINT "NewsletterSubscriber_consentVersion_not_null" NOT NULL "consentVersion",
	CONSTRAINT "NewsletterSubscriber_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "NewsletterSubscriber_email_not_null" NOT NULL email,
	CONSTRAINT "NewsletterSubscriber_id_not_null" NOT NULL id,
	CONSTRAINT "NewsletterSubscriber_pkey" PRIMARY KEY (id),
	CONSTRAINT "NewsletterSubscriber_status_not_null" NOT NULL status,
	CONSTRAINT "NewsletterSubscriber_updatedAt_not_null" NOT NULL "updatedAt"
);
CREATE UNIQUE INDEX "NewsletterSubscriber_email_key" ON public."NewsletterSubscriber" USING btree (email);
CREATE INDEX "NewsletterSubscriber_status_idx" ON public."NewsletterSubscriber" USING btree (status);

-- Permissions

ALTER TABLE public."NewsletterSubscriber" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."NewsletterSubscriber" TO neondb_owner;


-- public."ProcessedWebhook" definition

-- Drop table

-- DROP TABLE public."ProcessedWebhook";

CREATE TABLE public."ProcessedWebhook" (
	id text NOT NULL,
	provider text NOT NULL,
	"receivedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "ProcessedWebhook_id_not_null" NOT NULL id,
	CONSTRAINT "ProcessedWebhook_pkey" PRIMARY KEY (id),
	CONSTRAINT "ProcessedWebhook_provider_not_null" NOT NULL provider,
	CONSTRAINT "ProcessedWebhook_receivedAt_not_null" NOT NULL "receivedAt"
);
CREATE INDEX "ProcessedWebhook_provider_receivedAt_idx" ON public."ProcessedWebhook" USING btree (provider, "receivedAt");

-- Permissions

ALTER TABLE public."ProcessedWebhook" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."ProcessedWebhook" TO neondb_owner;


-- public."PromoCampaign" definition

-- Drop table

-- DROP TABLE public."PromoCampaign";

CREATE TABLE public."PromoCampaign" (
	id text NOT NULL,
	subject text NOT NULL,
	title text NOT NULL,
	body text NOT NULL,
	"ctaLabel" text NULL,
	"ctaPath" text NULL,
	"productIds" _text NULL,
	status public."PromoStatus" DEFAULT 'SENDING'::"PromoStatus" NOT NULL,
	"recipientCount" int4 DEFAULT 0 NOT NULL,
	"failedCount" int4 DEFAULT 0 NOT NULL,
	"createdById" text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"sentAt" timestamp(3) NULL,
	CONSTRAINT "PromoCampaign_body_not_null" NOT NULL body,
	CONSTRAINT "PromoCampaign_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "PromoCampaign_createdById_not_null" NOT NULL "createdById",
	CONSTRAINT "PromoCampaign_failedCount_not_null" NOT NULL "failedCount",
	CONSTRAINT "PromoCampaign_id_not_null" NOT NULL id,
	CONSTRAINT "PromoCampaign_pkey" PRIMARY KEY (id),
	CONSTRAINT "PromoCampaign_recipientCount_not_null" NOT NULL "recipientCount",
	CONSTRAINT "PromoCampaign_status_not_null" NOT NULL status,
	CONSTRAINT "PromoCampaign_subject_not_null" NOT NULL subject,
	CONSTRAINT "PromoCampaign_title_not_null" NOT NULL title
);
CREATE INDEX "PromoCampaign_createdAt_idx" ON public."PromoCampaign" USING btree ("createdAt");

-- Permissions

ALTER TABLE public."PromoCampaign" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."PromoCampaign" TO neondb_owner;


-- public."RefreshToken" definition

-- Drop table

-- DROP TABLE public."RefreshToken";

CREATE TABLE public."RefreshToken" (
	id text NOT NULL,
	"userId" text NOT NULL,
	"familyId" text NOT NULL,
	"expiresAt" timestamp(3) NOT NULL,
	"usedAt" timestamp(3) NULL,
	"revokedAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "RefreshToken_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "RefreshToken_expiresAt_not_null" NOT NULL "expiresAt",
	CONSTRAINT "RefreshToken_familyId_not_null" NOT NULL "familyId",
	CONSTRAINT "RefreshToken_id_not_null" NOT NULL id,
	CONSTRAINT "RefreshToken_pkey" PRIMARY KEY (id),
	CONSTRAINT "RefreshToken_userId_not_null" NOT NULL "userId"
);
CREATE INDEX "RefreshToken_expiresAt_idx" ON public."RefreshToken" USING btree ("expiresAt");
CREATE INDEX "RefreshToken_familyId_idx" ON public."RefreshToken" USING btree ("familyId");
CREATE INDEX "RefreshToken_userId_idx" ON public."RefreshToken" USING btree ("userId");

-- Permissions

ALTER TABLE public."RefreshToken" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."RefreshToken" TO neondb_owner;


-- public."RiskScore" definition

-- Drop table

-- DROP TABLE public."RiskScore";

CREATE TABLE public."RiskScore" (
	id text NOT NULL,
	"subjectType" public."RiskSubject" NOT NULL,
	"subjectId" text NOT NULL,
	score float8 NOT NULL,
	reasons jsonb NULL,
	"modelRunId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "RiskScore_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "RiskScore_id_not_null" NOT NULL id,
	CONSTRAINT "RiskScore_pkey" PRIMARY KEY (id),
	CONSTRAINT "RiskScore_score_not_null" NOT NULL score,
	CONSTRAINT "RiskScore_subjectId_not_null" NOT NULL "subjectId",
	CONSTRAINT "RiskScore_subjectType_not_null" NOT NULL "subjectType"
);
CREATE INDEX "RiskScore_subjectId_idx" ON public."RiskScore" USING btree ("subjectId");
CREATE INDEX "RiskScore_subjectType_score_idx" ON public."RiskScore" USING btree ("subjectType", score);

-- Permissions

ALTER TABLE public."RiskScore" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."RiskScore" TO neondb_owner;


-- public."SecurityIncident" definition

-- Drop table

-- DROP TABLE public."SecurityIncident";

CREATE TABLE public."SecurityIncident" (
	id text NOT NULL,
	"incidentNumber" serial4 NOT NULL,
	title text NOT NULL,
	description text NOT NULL,
	category public."IncidentCategory" NOT NULL,
	severity public."IncidentSeverity" NOT NULL,
	status public."IncidentStatus" DEFAULT 'OPEN'::"IncidentStatus" NOT NULL,
	"detectedAt" timestamp(3) NOT NULL,
	"affectsPersonalData" bool DEFAULT false NOT NULL,
	"affectedUsersEstimate" int4 NULL,
	"authorityName" text NULL,
	"authorityReportRef" text NULL,
	"authorityNotifiedAt" timestamp(3) NULL,
	"reportedBy" text NOT NULL,
	"resolvedAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	CONSTRAINT "SecurityIncident_affectsPersonalData_not_null" NOT NULL "affectsPersonalData",
	CONSTRAINT "SecurityIncident_category_not_null" NOT NULL category,
	CONSTRAINT "SecurityIncident_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "SecurityIncident_description_not_null" NOT NULL description,
	CONSTRAINT "SecurityIncident_detectedAt_not_null" NOT NULL "detectedAt",
	CONSTRAINT "SecurityIncident_id_not_null" NOT NULL id,
	CONSTRAINT "SecurityIncident_incidentNumber_not_null" NOT NULL "incidentNumber",
	CONSTRAINT "SecurityIncident_pkey" PRIMARY KEY (id),
	CONSTRAINT "SecurityIncident_reportedBy_not_null" NOT NULL "reportedBy",
	CONSTRAINT "SecurityIncident_severity_not_null" NOT NULL severity,
	CONSTRAINT "SecurityIncident_status_not_null" NOT NULL status,
	CONSTRAINT "SecurityIncident_title_not_null" NOT NULL title,
	CONSTRAINT "SecurityIncident_updatedAt_not_null" NOT NULL "updatedAt"
);
CREATE INDEX "SecurityIncident_category_idx" ON public."SecurityIncident" USING btree (category);
CREATE INDEX "SecurityIncident_createdAt_idx" ON public."SecurityIncident" USING btree ("createdAt");
CREATE UNIQUE INDEX "SecurityIncident_incidentNumber_key" ON public."SecurityIncident" USING btree ("incidentNumber");
CREATE INDEX "SecurityIncident_status_severity_idx" ON public."SecurityIncident" USING btree (status, severity);

-- Permissions

ALTER TABLE public."SecurityIncident" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."SecurityIncident" TO neondb_owner;


-- public."User" definition

-- Drop table

-- DROP TABLE public."User";

CREATE TABLE public."User" (
	id text NOT NULL,
	email text NOT NULL,
	"passwordHash" text NOT NULL,
	"role" public."Role" DEFAULT 'CLIENT'::"Role" NOT NULL,
	"firstName" text NULL,
	"lastName" text NULL,
	phone text NULL,
	"consentEssential" bool NOT NULL,
	"consentMarketing" bool DEFAULT false NOT NULL,
	"consentVersion" text NOT NULL,
	"consentAt" timestamp(3) NOT NULL,
	"consentIp" text NULL,
	"consentUpdatedAt" timestamp(3) NULL,
	"totpSecret" text NULL,
	"totpEnabledAt" timestamp(3) NULL,
	"isGuest" bool DEFAULT false NOT NULL,
	"emailVerified" timestamp(3) NULL,
	"lastLoginAt" timestamp(3) NULL,
	"failedLogins" int4 DEFAULT 0 NOT NULL,
	"lockedUntil" timestamp(3) NULL,
	"tokenVersion" int4 DEFAULT 0 NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	"deletedAt" timestamp(3) NULL,
	"totpLastStep" int4 NULL,
	CONSTRAINT "User_consentAt_not_null" NOT NULL "consentAt",
	CONSTRAINT "User_consentEssential_not_null" NOT NULL "consentEssential",
	CONSTRAINT "User_consentMarketing_not_null" NOT NULL "consentMarketing",
	CONSTRAINT "User_consentVersion_not_null" NOT NULL "consentVersion",
	CONSTRAINT "User_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "User_email_not_null" NOT NULL email,
	CONSTRAINT "User_failedLogins_not_null" NOT NULL "failedLogins",
	CONSTRAINT "User_id_not_null" NOT NULL id,
	CONSTRAINT "User_isGuest_not_null" NOT NULL "isGuest",
	CONSTRAINT "User_passwordHash_not_null" NOT NULL "passwordHash",
	CONSTRAINT "User_pkey" PRIMARY KEY (id),
	CONSTRAINT "User_role_not_null" NOT NULL role,
	CONSTRAINT "User_tokenVersion_not_null" NOT NULL "tokenVersion",
	CONSTRAINT "User_updatedAt_not_null" NOT NULL "updatedAt"
);
CREATE INDEX "User_email_idx" ON public."User" USING btree (email);
CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);
CREATE INDEX "User_role_idx" ON public."User" USING btree (role);

-- Permissions

ALTER TABLE public."User" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."User" TO neondb_owner;


-- public._prisma_migrations definition

-- Drop table

-- DROP TABLE public._prisma_migrations;

CREATE TABLE public._prisma_migrations (
	id varchar(36) NOT NULL,
	checksum varchar(64) NOT NULL,
	finished_at timestamptz NULL,
	migration_name varchar(255) NOT NULL,
	logs text NULL,
	rolled_back_at timestamptz NULL,
	started_at timestamptz DEFAULT now() NOT NULL,
	applied_steps_count int4 DEFAULT 0 NOT NULL,
	CONSTRAINT _prisma_migrations_applied_steps_count_not_null NOT NULL applied_steps_count,
	CONSTRAINT _prisma_migrations_checksum_not_null NOT NULL checksum,
	CONSTRAINT _prisma_migrations_id_not_null NOT NULL id,
	CONSTRAINT _prisma_migrations_migration_name_not_null NOT NULL migration_name,
	CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id),
	CONSTRAINT _prisma_migrations_started_at_not_null NOT NULL started_at
);

-- Permissions

ALTER TABLE public._prisma_migrations OWNER TO neondb_owner;
GRANT ALL ON TABLE public._prisma_migrations TO neondb_owner;


-- public."Address" definition

-- Drop table

-- DROP TABLE public."Address";

CREATE TABLE public."Address" (
	id text NOT NULL,
	"userId" text NOT NULL,
	"fullName" text NOT NULL,
	street text NOT NULL,
	"number" text NOT NULL,
	apartment text NULL,
	commune text NOT NULL,
	region text NOT NULL,
	phone text NOT NULL,
	notes text NULL,
	"isDefault" bool DEFAULT false NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "Address_commune_not_null" NOT NULL commune,
	CONSTRAINT "Address_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "Address_fullName_not_null" NOT NULL "fullName",
	CONSTRAINT "Address_id_not_null" NOT NULL id,
	CONSTRAINT "Address_isDefault_not_null" NOT NULL "isDefault",
	CONSTRAINT "Address_number_not_null" NOT NULL number,
	CONSTRAINT "Address_phone_not_null" NOT NULL phone,
	CONSTRAINT "Address_pkey" PRIMARY KEY (id),
	CONSTRAINT "Address_region_not_null" NOT NULL region,
	CONSTRAINT "Address_street_not_null" NOT NULL street,
	CONSTRAINT "Address_userId_not_null" NOT NULL "userId",
	CONSTRAINT "Address_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "Address_userId_idx" ON public."Address" USING btree ("userId");

-- Permissions

ALTER TABLE public."Address" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."Address" TO neondb_owner;


-- public."Order" definition

-- Drop table

-- DROP TABLE public."Order";

CREATE TABLE public."Order" (
	id text NOT NULL,
	"orderNumber" serial4 NOT NULL,
	"userId" text NOT NULL,
	"subtotalCLP" int4 NOT NULL,
	"shippingCLP" int4 NOT NULL,
	"totalCLP" int4 NOT NULL,
	status public."OrderStatus" DEFAULT 'PENDING'::"OrderStatus" NOT NULL,
	"paymentStatus" public."PaymentStatus" DEFAULT 'UNPAID'::"PaymentStatus" NOT NULL,
	"paymentProvider" text NULL,
	"paymentRef" text NULL,
	"paidAt" timestamp(3) NULL,
	"shippingMethod" public."ShippingMethod" DEFAULT 'STARKEN'::"ShippingMethod" NOT NULL,
	"shippingFullName" text NOT NULL,
	"shippingStreet" text NULL,
	"shippingNumber" text NULL,
	"shippingApartment" text NULL,
	"shippingCommune" text NULL,
	"shippingRegion" text NULL,
	"shippingPhone" text NOT NULL,
	"shippingNotes" text NULL,
	"trackingNumber" text NULL,
	"shippedAt" timestamp(3) NULL,
	"deliveredAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	CONSTRAINT "Order_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "Order_id_not_null" NOT NULL id,
	CONSTRAINT "Order_orderNumber_not_null" NOT NULL "orderNumber",
	CONSTRAINT "Order_paymentStatus_not_null" NOT NULL "paymentStatus",
	CONSTRAINT "Order_pkey" PRIMARY KEY (id),
	CONSTRAINT "Order_shippingCLP_not_null" NOT NULL "shippingCLP",
	CONSTRAINT "Order_shippingFullName_not_null" NOT NULL "shippingFullName",
	CONSTRAINT "Order_shippingMethod_not_null" NOT NULL "shippingMethod",
	CONSTRAINT "Order_shippingPhone_not_null" NOT NULL "shippingPhone",
	CONSTRAINT "Order_status_not_null" NOT NULL status,
	CONSTRAINT "Order_subtotalCLP_not_null" NOT NULL "subtotalCLP",
	CONSTRAINT "Order_totalCLP_not_null" NOT NULL "totalCLP",
	CONSTRAINT "Order_updatedAt_not_null" NOT NULL "updatedAt",
	CONSTRAINT "Order_userId_not_null" NOT NULL "userId",
	CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "Order_createdAt_idx" ON public."Order" USING btree ("createdAt");
CREATE UNIQUE INDEX "Order_orderNumber_key" ON public."Order" USING btree ("orderNumber");
CREATE INDEX "Order_paymentStatus_idx" ON public."Order" USING btree ("paymentStatus");
CREATE INDEX "Order_status_idx" ON public."Order" USING btree (status);
CREATE INDEX "Order_userId_idx" ON public."Order" USING btree ("userId");

-- Permissions

ALTER TABLE public."Order" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."Order" TO neondb_owner;


-- public."OrderStatusHistory" definition

-- Drop table

-- DROP TABLE public."OrderStatusHistory";

CREATE TABLE public."OrderStatusHistory" (
	id text NOT NULL,
	"orderId" text NOT NULL,
	"fromStatus" public."OrderStatus" NULL,
	"toStatus" public."OrderStatus" NOT NULL,
	"actorId" text NULL,
	note text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "OrderStatusHistory_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "OrderStatusHistory_id_not_null" NOT NULL id,
	CONSTRAINT "OrderStatusHistory_orderId_not_null" NOT NULL "orderId",
	CONSTRAINT "OrderStatusHistory_pkey" PRIMARY KEY (id),
	CONSTRAINT "OrderStatusHistory_toStatus_not_null" NOT NULL "toStatus",
	CONSTRAINT "OrderStatusHistory_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "OrderStatusHistory_orderId_createdAt_idx" ON public."OrderStatusHistory" USING btree ("orderId", "createdAt");
CREATE INDEX "OrderStatusHistory_toStatus_createdAt_idx" ON public."OrderStatusHistory" USING btree ("toStatus", "createdAt");

-- Permissions

ALTER TABLE public."OrderStatusHistory" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."OrderStatusHistory" TO neondb_owner;


-- public."Product" definition

-- Drop table

-- DROP TABLE public."Product";

CREATE TABLE public."Product" (
	id text NOT NULL,
	sku text NOT NULL,
	slug text NOT NULL,
	"name" text NOT NULL,
	"nameKorean" text NULL,
	description text NOT NULL,
	"priceCLP" int4 NOT NULL,
	stock int4 DEFAULT 0 NOT NULL,
	"lowStockThreshold" int4 DEFAULT 5 NOT NULL,
	"costCLP" int4 NULL,
	"weightGrams" int4 NOT NULL,
	images _text NULL,
	active bool DEFAULT true NOT NULL,
	"archivedAt" timestamp(3) NULL,
	featured bool DEFAULT false NOT NULL,
	"categoryId" text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	CONSTRAINT "Product_active_not_null" NOT NULL active,
	CONSTRAINT "Product_categoryId_not_null" NOT NULL "categoryId",
	CONSTRAINT "Product_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "Product_description_not_null" NOT NULL description,
	CONSTRAINT "Product_featured_not_null" NOT NULL featured,
	CONSTRAINT "Product_id_not_null" NOT NULL id,
	CONSTRAINT "Product_lowStockThreshold_not_null" NOT NULL "lowStockThreshold",
	CONSTRAINT "Product_name_not_null" NOT NULL name,
	CONSTRAINT "Product_pkey" PRIMARY KEY (id),
	CONSTRAINT "Product_priceCLP_not_null" NOT NULL "priceCLP",
	CONSTRAINT "Product_sku_not_null" NOT NULL sku,
	CONSTRAINT "Product_slug_not_null" NOT NULL slug,
	CONSTRAINT "Product_stock_not_null" NOT NULL stock,
	CONSTRAINT "Product_updatedAt_not_null" NOT NULL "updatedAt",
	CONSTRAINT "Product_weightGrams_not_null" NOT NULL "weightGrams",
	CONSTRAINT "Product_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "Product_active_archivedAt_idx" ON public."Product" USING btree (active, "archivedAt");
CREATE INDEX "Product_categoryId_idx" ON public."Product" USING btree ("categoryId");
CREATE UNIQUE INDEX "Product_sku_key" ON public."Product" USING btree (sku);
CREATE INDEX "Product_slug_idx" ON public."Product" USING btree (slug);
CREATE UNIQUE INDEX "Product_slug_key" ON public."Product" USING btree (slug);
CREATE INDEX "Product_stock_idx" ON public."Product" USING btree (stock);

-- Permissions

ALTER TABLE public."Product" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."Product" TO neondb_owner;


-- public."ProductRecommendation" definition

-- Drop table

-- DROP TABLE public."ProductRecommendation";

CREATE TABLE public."ProductRecommendation" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"recommendedProductId" text NOT NULL,
	strategy public."RecommendationStrategy" NOT NULL,
	score float8 NOT NULL,
	"modelRunId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "ProductRecommendation_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "ProductRecommendation_id_not_null" NOT NULL id,
	CONSTRAINT "ProductRecommendation_pkey" PRIMARY KEY (id),
	CONSTRAINT "ProductRecommendation_productId_not_null" NOT NULL "productId",
	CONSTRAINT "ProductRecommendation_recommendedProductId_not_null" NOT NULL "recommendedProductId",
	CONSTRAINT "ProductRecommendation_score_not_null" NOT NULL score,
	CONSTRAINT "ProductRecommendation_strategy_not_null" NOT NULL strategy,
	CONSTRAINT "ProductRecommendation_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT "ProductRecommendation_recommendedProductId_fkey" FOREIGN KEY ("recommendedProductId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "ProductRecommendation_productId_recommendedProductId_strate_key" ON public."ProductRecommendation" USING btree ("productId", "recommendedProductId", strategy);
CREATE INDEX "ProductRecommendation_productId_strategy_score_idx" ON public."ProductRecommendation" USING btree ("productId", strategy, score);

-- Permissions

ALTER TABLE public."ProductRecommendation" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."ProductRecommendation" TO neondb_owner;


-- public."RestockSuggestion" definition

-- Drop table

-- DROP TABLE public."RestockSuggestion";

CREATE TABLE public."RestockSuggestion" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"suggestedQty" int4 NOT NULL,
	reason text NOT NULL,
	"daysToStockout" int4 NULL,
	score float8 DEFAULT 0 NOT NULL,
	"modelRunId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "RestockSuggestion_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "RestockSuggestion_id_not_null" NOT NULL id,
	CONSTRAINT "RestockSuggestion_pkey" PRIMARY KEY (id),
	CONSTRAINT "RestockSuggestion_productId_not_null" NOT NULL "productId",
	CONSTRAINT "RestockSuggestion_reason_not_null" NOT NULL reason,
	CONSTRAINT "RestockSuggestion_score_not_null" NOT NULL score,
	CONSTRAINT "RestockSuggestion_suggestedQty_not_null" NOT NULL "suggestedQty",
	CONSTRAINT "RestockSuggestion_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "RestockSuggestion_productId_idx" ON public."RestockSuggestion" USING btree ("productId");
CREATE INDEX "RestockSuggestion_score_idx" ON public."RestockSuggestion" USING btree (score);

-- Permissions

ALTER TABLE public."RestockSuggestion" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."RestockSuggestion" TO neondb_owner;


-- public."ReturnRequest" definition

-- Drop table

-- DROP TABLE public."ReturnRequest";

CREATE TABLE public."ReturnRequest" (
	id text NOT NULL,
	"requestNumber" serial4 NOT NULL,
	"orderId" text NOT NULL,
	"userId" text NOT NULL,
	"type" public."ReturnType" NOT NULL,
	resolution public."ReturnResolution" NOT NULL,
	reason text NOT NULL,
	status public."ReturnStatus" DEFAULT 'REQUESTED'::"ReturnStatus" NOT NULL,
	"sellerNote" text NULL,
	restocked bool DEFAULT false NOT NULL,
	"refundCLP" int4 NULL,
	"decidedById" text NULL,
	"decidedAt" timestamp(3) NULL,
	"receivedAt" timestamp(3) NULL,
	"resolvedAt" timestamp(3) NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	CONSTRAINT "ReturnRequest_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "ReturnRequest_id_not_null" NOT NULL id,
	CONSTRAINT "ReturnRequest_orderId_not_null" NOT NULL "orderId",
	CONSTRAINT "ReturnRequest_pkey" PRIMARY KEY (id),
	CONSTRAINT "ReturnRequest_reason_not_null" NOT NULL reason,
	CONSTRAINT "ReturnRequest_requestNumber_not_null" NOT NULL "requestNumber",
	CONSTRAINT "ReturnRequest_resolution_not_null" NOT NULL resolution,
	CONSTRAINT "ReturnRequest_restocked_not_null" NOT NULL restocked,
	CONSTRAINT "ReturnRequest_status_not_null" NOT NULL status,
	CONSTRAINT "ReturnRequest_type_not_null" NOT NULL type,
	CONSTRAINT "ReturnRequest_updatedAt_not_null" NOT NULL "updatedAt",
	CONSTRAINT "ReturnRequest_userId_not_null" NOT NULL "userId",
	CONSTRAINT "ReturnRequest_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "ReturnRequest_orderId_idx" ON public."ReturnRequest" USING btree ("orderId");
CREATE UNIQUE INDEX "ReturnRequest_requestNumber_key" ON public."ReturnRequest" USING btree ("requestNumber");
CREATE INDEX "ReturnRequest_status_createdAt_idx" ON public."ReturnRequest" USING btree (status, "createdAt");
CREATE INDEX "ReturnRequest_userId_idx" ON public."ReturnRequest" USING btree ("userId");

-- Permissions

ALTER TABLE public."ReturnRequest" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."ReturnRequest" TO neondb_owner;


-- public."SecurityIncidentEvent" definition

-- Drop table

-- DROP TABLE public."SecurityIncidentEvent";

CREATE TABLE public."SecurityIncidentEvent" (
	id text NOT NULL,
	"incidentId" text NOT NULL,
	seq int4 NOT NULL,
	"type" public."IncidentEventType" NOT NULL,
	detail text NOT NULL,
	"actorId" text NOT NULL,
	"prevHash" text NULL,
	hash text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "SecurityIncidentEvent_actorId_not_null" NOT NULL "actorId",
	CONSTRAINT "SecurityIncidentEvent_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "SecurityIncidentEvent_detail_not_null" NOT NULL detail,
	CONSTRAINT "SecurityIncidentEvent_hash_not_null" NOT NULL hash,
	CONSTRAINT "SecurityIncidentEvent_id_not_null" NOT NULL id,
	CONSTRAINT "SecurityIncidentEvent_incidentId_not_null" NOT NULL "incidentId",
	CONSTRAINT "SecurityIncidentEvent_pkey" PRIMARY KEY (id),
	CONSTRAINT "SecurityIncidentEvent_seq_not_null" NOT NULL seq,
	CONSTRAINT "SecurityIncidentEvent_type_not_null" NOT NULL type,
	CONSTRAINT "SecurityIncidentEvent_incidentId_fkey" FOREIGN KEY ("incidentId") REFERENCES public."SecurityIncident"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "SecurityIncidentEvent_incidentId_createdAt_idx" ON public."SecurityIncidentEvent" USING btree ("incidentId", "createdAt");
CREATE UNIQUE INDEX "SecurityIncidentEvent_incidentId_seq_key" ON public."SecurityIncidentEvent" USING btree ("incidentId", seq);

-- Permissions

ALTER TABLE public."SecurityIncidentEvent" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."SecurityIncidentEvent" TO neondb_owner;


-- public."StockAdjustment" definition

-- Drop table

-- DROP TABLE public."StockAdjustment";

CREATE TABLE public."StockAdjustment" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"previousStock" int4 NOT NULL,
	"newStock" int4 NOT NULL,
	delta int4 NOT NULL,
	reason public."StockMovementReason" NOT NULL,
	notes text NULL,
	"actorId" text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "StockAdjustment_actorId_not_null" NOT NULL "actorId",
	CONSTRAINT "StockAdjustment_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "StockAdjustment_delta_not_null" NOT NULL delta,
	CONSTRAINT "StockAdjustment_id_not_null" NOT NULL id,
	CONSTRAINT "StockAdjustment_newStock_not_null" NOT NULL "newStock",
	CONSTRAINT "StockAdjustment_pkey" PRIMARY KEY (id),
	CONSTRAINT "StockAdjustment_previousStock_not_null" NOT NULL "previousStock",
	CONSTRAINT "StockAdjustment_productId_not_null" NOT NULL "productId",
	CONSTRAINT "StockAdjustment_reason_not_null" NOT NULL reason,
	CONSTRAINT "StockAdjustment_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "StockAdjustment_actorId_idx" ON public."StockAdjustment" USING btree ("actorId");
CREATE INDEX "StockAdjustment_productId_createdAt_idx" ON public."StockAdjustment" USING btree ("productId", "createdAt");

-- Permissions

ALTER TABLE public."StockAdjustment" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."StockAdjustment" TO neondb_owner;


-- public."StockMovement" definition

-- Drop table

-- DROP TABLE public."StockMovement";

CREATE TABLE public."StockMovement" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"type" public."StockMovementType" NOT NULL,
	reason public."StockMovementReason" NOT NULL,
	quantity int4 NOT NULL,
	"previousStock" int4 NOT NULL,
	"resultingStock" int4 NOT NULL,
	"orderId" text NULL,
	"adjustmentId" text NULL,
	"actorId" text NULL,
	notes text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "StockMovement_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "StockMovement_id_not_null" NOT NULL id,
	CONSTRAINT "StockMovement_pkey" PRIMARY KEY (id),
	CONSTRAINT "StockMovement_previousStock_not_null" NOT NULL "previousStock",
	CONSTRAINT "StockMovement_productId_not_null" NOT NULL "productId",
	CONSTRAINT "StockMovement_quantity_not_null" NOT NULL quantity,
	CONSTRAINT "StockMovement_reason_not_null" NOT NULL reason,
	CONSTRAINT "StockMovement_resultingStock_not_null" NOT NULL "resultingStock",
	CONSTRAINT "StockMovement_type_not_null" NOT NULL type,
	CONSTRAINT "StockMovement_adjustmentId_fkey" FOREIGN KEY ("adjustmentId") REFERENCES public."StockAdjustment"(id) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT "StockMovement_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT "StockMovement_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "StockMovement_orderId_idx" ON public."StockMovement" USING btree ("orderId");
CREATE INDEX "StockMovement_productId_createdAt_idx" ON public."StockMovement" USING btree ("productId", "createdAt");
CREATE INDEX "StockMovement_type_createdAt_idx" ON public."StockMovement" USING btree (type, "createdAt");

-- Permissions

ALTER TABLE public."StockMovement" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."StockMovement" TO neondb_owner;


-- public."StockReservation" definition

-- Drop table

-- DROP TABLE public."StockReservation";

CREATE TABLE public."StockReservation" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"orderId" text NOT NULL,
	quantity int4 NOT NULL,
	"expiresAt" timestamp(3) NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "StockReservation_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "StockReservation_expiresAt_not_null" NOT NULL "expiresAt",
	CONSTRAINT "StockReservation_id_not_null" NOT NULL id,
	CONSTRAINT "StockReservation_orderId_not_null" NOT NULL "orderId",
	CONSTRAINT "StockReservation_pkey" PRIMARY KEY (id),
	CONSTRAINT "StockReservation_productId_not_null" NOT NULL "productId",
	CONSTRAINT "StockReservation_quantity_not_null" NOT NULL quantity,
	CONSTRAINT "StockReservation_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT "StockReservation_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "StockReservation_expiresAt_idx" ON public."StockReservation" USING btree ("expiresAt");
CREATE UNIQUE INDEX "StockReservation_orderId_productId_key" ON public."StockReservation" USING btree ("orderId", "productId");
CREATE INDEX "StockReservation_productId_expiresAt_idx" ON public."StockReservation" USING btree ("productId", "expiresAt");

-- Permissions

ALTER TABLE public."StockReservation" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."StockReservation" TO neondb_owner;


-- public."DemandForecast" definition

-- Drop table

-- DROP TABLE public."DemandForecast";

CREATE TABLE public."DemandForecast" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"periodStart" timestamp(3) NOT NULL,
	"horizonDays" int4 NOT NULL,
	"predictedQty" int4 NOT NULL,
	"lowerQty" int4 NULL,
	"upperQty" int4 NULL,
	"modelRunId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "DemandForecast_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "DemandForecast_horizonDays_not_null" NOT NULL "horizonDays",
	CONSTRAINT "DemandForecast_id_not_null" NOT NULL id,
	CONSTRAINT "DemandForecast_periodStart_not_null" NOT NULL "periodStart",
	CONSTRAINT "DemandForecast_pkey" PRIMARY KEY (id),
	CONSTRAINT "DemandForecast_predictedQty_not_null" NOT NULL "predictedQty",
	CONSTRAINT "DemandForecast_productId_not_null" NOT NULL "productId",
	CONSTRAINT "DemandForecast_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "DemandForecast_periodStart_idx" ON public."DemandForecast" USING btree ("periodStart");
CREATE UNIQUE INDEX "DemandForecast_productId_periodStart_horizonDays_key" ON public."DemandForecast" USING btree ("productId", "periodStart", "horizonDays");

-- Permissions

ALTER TABLE public."DemandForecast" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."DemandForecast" TO neondb_owner;


-- public."OrderItem" definition

-- Drop table

-- DROP TABLE public."OrderItem";

CREATE TABLE public."OrderItem" (
	id text NOT NULL,
	"orderId" text NOT NULL,
	"productId" text NOT NULL,
	quantity int4 NOT NULL,
	"unitPriceCLP" int4 NOT NULL,
	"productName" text NOT NULL,
	CONSTRAINT "OrderItem_id_not_null" NOT NULL id,
	CONSTRAINT "OrderItem_orderId_not_null" NOT NULL "orderId",
	CONSTRAINT "OrderItem_pkey" PRIMARY KEY (id),
	CONSTRAINT "OrderItem_productId_not_null" NOT NULL "productId",
	CONSTRAINT "OrderItem_productName_not_null" NOT NULL "productName",
	CONSTRAINT "OrderItem_quantity_not_null" NOT NULL quantity,
	CONSTRAINT "OrderItem_unitPriceCLP_not_null" NOT NULL "unitPriceCLP",
	CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Order"(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "OrderItem_orderId_idx" ON public."OrderItem" USING btree ("orderId");

-- Permissions

ALTER TABLE public."OrderItem" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."OrderItem" TO neondb_owner;


-- public."PriceHistory" definition

-- Drop table

-- DROP TABLE public."PriceHistory";

CREATE TABLE public."PriceHistory" (
	id text NOT NULL,
	"productId" text NOT NULL,
	"previousCLP" int4 NOT NULL,
	"newCLP" int4 NOT NULL,
	"actorId" text NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "PriceHistory_createdAt_not_null" NOT NULL "createdAt",
	CONSTRAINT "PriceHistory_id_not_null" NOT NULL id,
	CONSTRAINT "PriceHistory_newCLP_not_null" NOT NULL "newCLP",
	CONSTRAINT "PriceHistory_pkey" PRIMARY KEY (id),
	CONSTRAINT "PriceHistory_previousCLP_not_null" NOT NULL "previousCLP",
	CONSTRAINT "PriceHistory_productId_not_null" NOT NULL "productId",
	CONSTRAINT "PriceHistory_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "PriceHistory_productId_createdAt_idx" ON public."PriceHistory" USING btree ("productId", "createdAt");

-- Permissions

ALTER TABLE public."PriceHistory" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."PriceHistory" TO neondb_owner;


-- public."ReturnItem" definition

-- Drop table

-- DROP TABLE public."ReturnItem";

CREATE TABLE public."ReturnItem" (
	id text NOT NULL,
	"returnId" text NOT NULL,
	"orderItemId" text NOT NULL,
	quantity int4 NOT NULL,
	CONSTRAINT "ReturnItem_id_not_null" NOT NULL id,
	CONSTRAINT "ReturnItem_orderItemId_not_null" NOT NULL "orderItemId",
	CONSTRAINT "ReturnItem_pkey" PRIMARY KEY (id),
	CONSTRAINT "ReturnItem_quantity_not_null" NOT NULL quantity,
	CONSTRAINT "ReturnItem_returnId_not_null" NOT NULL "returnId",
	CONSTRAINT "ReturnItem_orderItemId_fkey" FOREIGN KEY ("orderItemId") REFERENCES public."OrderItem"(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT "ReturnItem_returnId_fkey" FOREIGN KEY ("returnId") REFERENCES public."ReturnRequest"(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX "ReturnItem_orderItemId_idx" ON public."ReturnItem" USING btree ("orderItemId");
CREATE INDEX "ReturnItem_returnId_idx" ON public."ReturnItem" USING btree ("returnId");

-- Permissions

ALTER TABLE public."ReturnItem" OWNER TO neondb_owner;
GRANT ALL ON TABLE public."ReturnItem" TO neondb_owner;




-- Permissions

GRANT ALL ON SCHEMA public TO pg_database_owner;
GRANT USAGE ON SCHEMA public TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT SELECT, USAGE, UPDATE ON SEQUENCES TO neon_superuser WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT MAINTAIN, INSERT, SELECT, TRIGGER, DELETE, REFERENCES, UPDATE, TRUNCATE ON TABLES TO neon_superuser WITH GRANT OPTION;