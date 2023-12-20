-- MySQL dump 10.13  Distrib 8.1.0, for Win64 (x86_64)
--
-- Host: localhost    Database: guydigital_dev
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accidents`
--

DROP TABLE IF EXISTS `accidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accidents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `body_injuries` tinyint(1) NOT NULL,
  `body_injuries_description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Only if there are body injuries',
  PRIMARY KEY (`id`),
  KEY `accidents_rental_id` (`rental_id`),
  CONSTRAINT `accidents_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accidents`
--

LOCK TABLES `accidents` WRITE;
/*!40000 ALTER TABLE `accidents` DISABLE KEYS */;
/*!40000 ALTER TABLE `accidents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car_categories`
--

DROP TABLE IF EXISTS `car_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_categories` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `price_per_day` float NOT NULL,
  `price_extra_km` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_categories`
--

LOCK TABLES `car_categories` WRITE;
/*!40000 ALTER TABLE `car_categories` DISABLE KEYS */;
INSERT INTO `car_categories` VALUES (1,'A',115,0.575);
/*!40000 ALTER TABLE `car_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car_types`
--

DROP TABLE IF EXISTS `car_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_types` (
  `car_type_id` smallint NOT NULL,
  `car_type_description` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `category` smallint unsigned NOT NULL,
  `instructions_file` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Needs to point to a text file on the disk.',
  `instructions_video` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'HTTP link to the video.',
  PRIMARY KEY (`car_type_id`),
  KEY `car_types_category` (`category`),
  CONSTRAINT `car_types_category` FOREIGN KEY (`category`) REFERENCES `car_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_types`
--

LOCK TABLES `car_types` WRITE;
/*!40000 ALTER TABLE `car_types` DISABLE KEYS */;
INSERT INTO `car_types` VALUES (1,'KIA',1,NULL,NULL);
/*!40000 ALTER TABLE `car_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cars`
--

DROP TABLE IF EXISTS `cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cars` (
  `car_license_number` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Stored as text in case it begins with a zero. Do not include dashes.',
  `car_type` smallint unsigned NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`car_license_number`),
  KEY `cars_car_type` (`car_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cars`
--

LOCK TABLES `cars` WRITE;
/*!40000 ALTER TABLE `cars` DISABLE KEYS */;
INSERT INTO `cars` VALUES ('1662465',1,NULL);
/*!40000 ALTER TABLE `cars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuration`
--

DROP TABLE IF EXISTS `configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuration` (
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuration`
--

LOCK TABLES `configuration` WRITE;
/*!40000 ALTER TABLE `configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `damages`
--

DROP TABLE IF EXISTS `damages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `damages` (
  `id` int unsigned NOT NULL,
  `rental_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `damages_rental_id` (`rental_id`),
  CONSTRAINT `damages_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `damages`
--

LOCK TABLES `damages` WRITE;
/*!40000 ALTER TABLE `damages` DISABLE KEYS */;
/*!40000 ALTER TABLE `damages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_types`
--

DROP TABLE IF EXISTS `expense_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_types` (
  `id` smallint unsigned NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_types`
--

LOCK TABLES `expense_types` WRITE;
/*!40000 ALTER TABLE `expense_types` DISABLE KEYS */;
INSERT INTO `expense_types` VALUES (1,'דלק'),(2,'אוראה'),(3,'נוזל חלונות'),(4,'שמן'),(5,'מגבים'),(6,'פנצ\'רים'),(7,'אחר');
/*!40000 ALTER TABLE `expense_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `expense_type` smallint unsigned NOT NULL,
  `amount` float NOT NULL COMMENT 'e.g., if type is gas then this is the number of liters.',
  `total_price` float NOT NULL,
  `comment` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `invoice_file` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Path to a file containing the invoice photo.',
  PRIMARY KEY (`id`),
  KEY `expenses_rental_id` (`rental_id`),
  KEY `expenses_expense_type` (`expense_type`),
  CONSTRAINT `expenses_expense_type` FOREIGN KEY (`expense_type`) REFERENCES `expense_types` (`id`),
  CONSTRAINT `expenses_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faults`
--

DROP TABLE IF EXISTS `faults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faults` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `faults_rental_id` (`rental_id`),
  CONSTRAINT `faults_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faults`
--

LOCK TABLES `faults` WRITE;
/*!40000 ALTER TABLE `faults` DISABLE KEYS */;
/*!40000 ALTER TABLE `faults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fines`
--

DROP TABLE IF EXISTS `fines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fines` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `fine_type` tinyint unsigned NOT NULL COMMENT '1 = Police, 2 = Parking',
  `sum` float NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fines_rental_id` (`rental_id`),
  CONSTRAINT `fines_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fines`
--

LOCK TABLES `fines` WRITE;
/*!40000 ALTER TABLE `fines` DISABLE KEYS */;
/*!40000 ALTER TABLE `fines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message_templates`
--

DROP TABLE IF EXISTS `message_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_templates` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Internal description (shown in admin interface only).',
  `recipients` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `subject` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_templates`
--

LOCK TABLES `message_templates` WRITE;
/*!40000 ALTER TABLE `message_templates` DISABLE KEYS */;
INSERT INTO `message_templates` VALUES (1,'אין כרטיס אשראי/ פג תוקף','y','אין כרטיס אשראי/ פג תוקף','שלום, '),(2,'פרטי המשתמש שונו','ט','פרטי המשתמש שונו','שלום,'),(3,'תאריך ההחזרה שונה ','y','תאריך ההחזרה שונה ','שלום,'),(4,'אין התאמה של הנסועה ','ט','אין התאמה של הנסועה ','שלום,'),(5,'פער בתאריך בהחזרת הרכב ','ט','פער בתאריך בהחזרת הרכב ','שלום,'),(6,'פער בנסועה חזור ','ט','פער בנסועה חזור ','שלום,'),(7,'נזק ','ט','נזק ','שלום,'),(8,'תאונה ','ט','תאונה ','שלום,'),(9,'דו\"חות','ט','דו\"חות','שלום,'),(10,'תאריך האיסוף בפועל שונה מתאריך האיסוף הקבוע בהזמנה','ט','תאריך האיסוף בפועל שונה מתאריך האיסוף הקבוע בהזמנה','שלום, '),(11,'מייל תזכורת ללקוח ','ט','מייל תזכורת ללקוח ','שלום << שם הלקוח>>'),(12,'קיים כרטיס במערכת','ט','קיים כרטיס במערכת','שלום, '),(13,'הלקוח מבקש לשנות את מספר הרישוי ','ט','הלקוח מבקש לשנות את מספר הרישוי ','שלום,');
/*!40000 ALTER TABLE `message_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `template_id` smallint unsigned NOT NULL,
  `time_sent` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recipients` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `subject` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` tinyint unsigned NOT NULL COMMENT '0 = Pending, 1 = In Progress, 2 = Sent, 3 = Error',
  PRIMARY KEY (`id`),
  KEY `messages_rental_id` (`rental_id`),
  KEY `messages_template_id` (`template_id`),
  CONSTRAINT `messages_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`),
  CONSTRAINT `messages_template_id` FOREIGN KEY (`template_id`) REFERENCES `message_templates` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (73,2,1,'2023-09-07 15:34:47','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(74,3,1,'2023-09-07 15:34:58','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(75,4,1,'2023-09-07 15:34:58','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(76,5,1,'2023-09-10 11:50:24','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(77,6,1,'2023-09-10 11:51:10','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(78,7,1,'2023-09-10 11:56:29','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(79,8,1,'2023-09-10 11:56:29','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(80,8,10,'2023-09-10 12:14:01','ט','תאריך האיסוף בפועל שונה מתאריך האיסוף הקבוע בהזמנה','<p> שלום, <br/> הלקוח: meir dan ת\"ז: 315554568 מספר הזמנה: 9101112 <br/>\nאסף את הרכב סוג הרכב:KIA מספר רישוי: 1662465 בתאריך: 2023-09-10 <br/> \nבשונה ממועד האיסוף המתוכנן שנקבע בתאריך 30/08/2023 \n <br/>\nלבדיקתך, <br/>\nתודה רבה!\n <p/>',0),(81,8,10,'2023-09-10 12:19:13','ט','תאריך האיסוף בפועל שונה מתאריך האיסוף הקבוע בהזמנה','<p> שלום, <br/> הלקוח: meir dan ת\"ז: 315554568 מספר הזמנה: 9101112 <br/>\nאסף את הרכב סוג הרכב:KIA מספר רישוי: 1662465 בתאריך: 2023-09-10 <br/> \nבשונה ממועד האיסוף המתוכנן שנקבע בתאריך 30/08/2023 \n <br/>\nלבדיקתך, <br/>\nתודה רבה!\n <p/>',0),(82,9,1,'2023-09-10 12:20:09','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(83,10,1,'2023-09-10 12:20:09','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(84,11,1,'2023-09-10 12:26:06','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0),(85,12,1,'2023-09-10 12:26:07','y','אין כרטיס אשראי/ פג תוקף','<p> שלום, <br/>\nפרטי כרטיס אשראי של הלקוח: meir dan ת\"ז: 315554568 לא בתוקף/ לא קיימים.<p/>\n<p> נא ליצור איתו קשר בהקדם. <br/>\nתודה רבה!<p/>\n',0);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int unsigned NOT NULL COMMENT 'Do not set to auto increment since this is imported from Priority.',
  `customer_id` int unsigned NOT NULL,
  `driver_id` int unsigned DEFAULT NULL,
  `car_license_number` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `car_category` smallint unsigned NOT NULL,
  `price_per_day` float NOT NULL,
  `invoice_recipient_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `orders_customer_id` (`customer_id`),
  KEY `orders_car_license_number` (`car_license_number`),
  KEY `orders_car_category` (`car_category`),
  KEY `orders_driver_id` (`driver_id`),
  KEY `orders_invoice_recipient_id` (`invoice_recipient_id`),
  CONSTRAINT `orders_car_category` FOREIGN KEY (`car_category`) REFERENCES `car_categories` (`id`),
  CONSTRAINT `orders_car_license_number` FOREIGN KEY (`car_license_number`) REFERENCES `cars` (`car_license_number`),
  CONSTRAINT `orders_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_invoice_recipient_id` FOREIGN KEY (`invoice_recipient_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (9101112,1,NULL,'1662465','2023-08-30','2023-09-10',1,115,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_types`
--

DROP TABLE IF EXISTS `photo_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `photo_types` (
  `id` smallint unsigned NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photo_types`
--

LOCK TABLES `photo_types` WRITE;
/*!40000 ALTER TABLE `photo_types` DISABLE KEYS */;
INSERT INTO `photo_types` VALUES (1,'front'),(2,'right'),(3,'left'),(4,'back'),(5,'damage'),(6,'dashboard');
/*!40000 ALTER TABLE `photo_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `photos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `photo_type` smallint unsigned NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `car_license_number` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `photo_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file_name` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Full path of the photo file on disk.',
  PRIMARY KEY (`id`),
  KEY `photos_rental_id` (`rental_id`),
  KEY `photos_photo_type` (`photo_type`),
  KEY `photos_car_license_number` (`car_license_number`),
  CONSTRAINT `photos_car_license_number` FOREIGN KEY (`car_license_number`) REFERENCES `cars` (`car_license_number`),
  CONSTRAINT `photos_photo_type` FOREIGN KEY (`photo_type`) REFERENCES `photo_types` (`id`),
  CONSTRAINT `photos_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (2,8,6,'','1662465','2023-09-10 00:00:00','dashboard9101112112132023-09-10.jpg'),(3,10,1,'','1662465','2023-09-10 00:00:00','front9101112112132023-09-10.jpg'),(4,10,1,'','1662465','2023-09-10 00:00:00','front9101112112132023-09-10.jpg'),(5,10,2,'','1662465','2023-09-10 00:00:00','right9101112112132023-09-10.jpg'),(6,10,4,'','1662465','2023-09-10 00:00:00','back9101112112132023-09-10.jpg'),(7,10,3,'','1662465','2023-09-10 00:00:00','left9101112112132023-09-10.jpg'),(8,12,6,'','1662465','2023-09-10 00:00:00','dashboard9101112112132023-09-10.jpg');
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rentals`
--

DROP TABLE IF EXISTS `rentals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rentals` (
  `rental_id` int unsigned NOT NULL AUTO_INCREMENT,
  `car_license_number` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `driver_id` int unsigned NOT NULL,
  `order_id` int unsigned NOT NULL,
  `pickup_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estimated_return_time` datetime NOT NULL,
  `actual_return_time` datetime DEFAULT NULL,
  `credit_card_change_num` smallint unsigned DEFAULT NULL,
  `credit_card_change_validity` date DEFAULT NULL,
  `pickup_kilometers` int unsigned NOT NULL,
  `return_kilometers` int unsigned DEFAULT NULL,
  PRIMARY KEY (`rental_id`),
  KEY `rentals_car_license_number` (`car_license_number`),
  KEY `rentals_order_id` (`order_id`),
  KEY `rentals_driver_id` (`driver_id`),
  CONSTRAINT `rentals_car_license_number` FOREIGN KEY (`car_license_number`) REFERENCES `cars` (`car_license_number`),
  CONSTRAINT `rentals_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `rentals_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rentals`
--

LOCK TABLES `rentals` WRITE;
/*!40000 ALTER TABLE `rentals` DISABLE KEYS */;
INSERT INTO `rentals` VALUES (1,'1662465',1,9101112,'2024-01-01 10:28:00','2024-01-01 16:29:00',NULL,1234,'2032-12-01',1234,NULL),(2,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(3,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(4,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(5,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(6,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(7,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(8,'1662465',1,9101112,'2024-01-01 11:56:00','2024-01-01 12:34:00','2024-01-01 12:19:00',NULL,NULL,1234,1234),(9,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(10,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(11,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL),(12,'1662465',1,9101112,'2024-01-01 00:00:00','2024-01-01 00:00:00',NULL,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `rentals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toll_road_use`
--

DROP TABLE IF EXISTS `toll_road_use`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toll_road_use` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rental_id` int unsigned NOT NULL,
  `use_date` date NOT NULL COMMENT 'If the customer used toll roads on multiple days, multiple rows should be created, even for a single rental.',
  `road_id` smallint unsigned NOT NULL,
  `number_of_uses` smallint unsigned NOT NULL COMMENT 'Per day.',
  `price` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `toll_road_use_rental_id` (`rental_id`),
  KEY `toll_road_use_road_id` (`road_id`),
  CONSTRAINT `toll_road_use_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`),
  CONSTRAINT `toll_road_use_road_id` FOREIGN KEY (`road_id`) REFERENCES `toll_roads` (`road_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toll_road_use`
--

LOCK TABLES `toll_road_use` WRITE;
/*!40000 ALTER TABLE `toll_road_use` DISABLE KEYS */;
/*!40000 ALTER TABLE `toll_road_use` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toll_roads`
--

DROP TABLE IF EXISTS `toll_roads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toll_roads` (
  `road_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `road_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `road_price` float NOT NULL,
  PRIMARY KEY (`road_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toll_roads`
--

LOCK TABLES `toll_roads` WRITE;
/*!40000 ALTER TABLE `toll_roads` DISABLE KEYS */;
INSERT INTO `toll_roads` VALUES (1,'כביש 6',6),(2,'כביש 6 צפון',8),(3,'מנהרות הכרמל',9),(4,'הנתיב המהיר',12);
/*!40000 ALTER TABLE `toll_roads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gov_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'If not Israeli, should be prefixed by a two letter country code (e.g., US12345678).',
  `user_type` tinyint unsigned NOT NULL,
  `first_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `last_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `phone` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `address` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `city` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `zip` int unsigned NOT NULL,
  `country` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `passport_photo` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Only if country is not Israel. Path to file on disk.',
  `visa_photo` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Only if country is not Israel. Path to file on disk.',
  `drivers_license` int unsigned DEFAULT NULL,
  `drivers_license_validity` date DEFAULT NULL,
  `credit_card` smallint unsigned NOT NULL COMMENT 'Since there''s no MM/YYYY type we use a standard DATETIME type. The DD values will be ignored since credit cards always expire at the end of the month.',
  `credit_card_validity` date NOT NULL,
  `health_declaration_validity` year NOT NULL COMMENT 'Only the year is stored since health declarations are valid until the end of the year.',
  `driver_code` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Code received from Ituran, used by the driver to start the vehicle. Stored as varchar since it may begin with a zero.',
  `token` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Token sent via SMS or email during the login process. Should be cleared once the user logs in.',
  `token_validity` datetime DEFAULT NULL COMMENT 'If NULL then the token is considered invalid.',
  `cookie` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Session cookie used to keep the user logged-in.',
  `cookie_validity` datetime DEFAULT NULL COMMENT 'If NULL then if never expires.',
  `permissions` smallint unsigned NOT NULL COMMENT 'Bitmask: Customer / Administrative driver / Manager / Admin',
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `gov_id` (`gov_id`),
  UNIQUE KEY `token` (`token`,`cookie`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'315554568',1,'meir','dan','0544381062','meird1995@gmail.com','nedvorna','beytar',1111111,'israel','passport_photo-9101112-11213-23-09-03-15-16-30.jpg',NULL,11213,'2024-08-29',2222,'2023-08-29',2023,'11213',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-10 12:34:49
