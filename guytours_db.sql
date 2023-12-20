-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 28, 2023 at 09:03 AM
-- Server version: 5.7.23-23
-- PHP Version: 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `guytours_guydigital_dev`
--

-- --------------------------------------------------------

--
-- Table structure for table `accidents`
--

DROP TABLE IF EXISTS `accidents`;
CREATE TABLE `accidents` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `description` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `body_injuries` tinyint(1) NOT NULL,
  `body_injuries_description` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Only if there are body injuries'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

DROP TABLE IF EXISTS `cars`;
CREATE TABLE `cars` (
  `car_license_number` varchar(16) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Stored as text in case it begins with a zero. Do not include dashes.',
  `car_type` smallint(5) UNSIGNED NOT NULL,
  `description` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `car_categories`
--

DROP TABLE IF EXISTS `car_categories`;
CREATE TABLE `car_categories` (
  `id` smallint(10) UNSIGNED NOT NULL,
  `cat_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `price_per_day` float NOT NULL,
  `price_extra_km` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `car_types`
--

DROP TABLE IF EXISTS `car_types`;
CREATE TABLE `car_types` (
  `car_type_id` smallint(6) NOT NULL,
  `car_type_description` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `category` smallint(5) UNSIGNED NOT NULL,
  `instructions_file` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Needs to point to a text file on the disk.',
  `instructions_video` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'HTTP link to the video.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `configuration`
--

DROP TABLE IF EXISTS `configuration`;
CREATE TABLE `configuration` (
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `value` varchar(256) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `damages`
--

DROP TABLE IF EXISTS `damages`;
CREATE TABLE `damages` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `description` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
CREATE TABLE `expenses` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `expense_type` smallint(5) UNSIGNED NOT NULL,
  `amount` float NOT NULL COMMENT 'e.g., if type is gas then this is the number of liters.',
  `total_price` float NOT NULL,
  `comment` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `invoice_file` varchar(256) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Path to a file containing the invoice photo.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expense_types`
--

DROP TABLE IF EXISTS `expense_types`;
CREATE TABLE `expense_types` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `description` varchar(256) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faults`
--

DROP TABLE IF EXISTS `faults`;
CREATE TABLE `faults` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `description` varchar(1024) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

DROP TABLE IF EXISTS `fines`;
CREATE TABLE `fines` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `fine_type` tinyint(3) UNSIGNED NOT NULL COMMENT '1 = Police, 2 = Parking',
  `sum` float NOT NULL,
  `description` varchar(256) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `template_id` smallint(5) UNSIGNED NOT NULL,
  `time_sent` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recipients` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `subject` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `text` text COLLATE utf8_unicode_ci NOT NULL,
  `status` tinyint(3) UNSIGNED NOT NULL COMMENT '0 = Pending, 1 = In Progress, 2 = Sent, 3 = Error'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `message_templates`
--

DROP TABLE IF EXISTS `message_templates`;
CREATE TABLE `message_templates` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `description` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Internal description (shown in admin interface only).',
  `recipients` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `subject` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `text` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` int(10) UNSIGNED NOT NULL COMMENT 'Do not set to auto increment since this is imported from Priority.',
  `customer_id` int(10) UNSIGNED NOT NULL,
  `driver_id` int(10) UNSIGNED DEFAULT NULL,
  `car_license_number` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `car_category` smallint(5) UNSIGNED NOT NULL,
  `price_per_day` float NOT NULL,
  `invoice_recipient_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `photo_type` smallint(5) UNSIGNED NOT NULL,
  `description` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_license_number` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `photo_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Full path of the photo file on disk.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `photo_types`
--

DROP TABLE IF EXISTS `photo_types`;
CREATE TABLE `photo_types` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `description` varchar(256) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rentals`
--

DROP TABLE IF EXISTS `rentals`;
CREATE TABLE `rentals` (
  `rental_id` int(10) UNSIGNED NOT NULL,
  `car_license_number` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `driver_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `pickup_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estimated_return_time` datetime NOT NULL,
  `actual_return_time` datetime DEFAULT NULL,
  `credit_card_change_num` smallint(5) UNSIGNED DEFAULT NULL,
  `credit_card_change_validity` date DEFAULT NULL,
  `pickup_kilometers` int(10) UNSIGNED NOT NULL,
  `return_kilometers` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `toll_roads`
--

DROP TABLE IF EXISTS `toll_roads`;
CREATE TABLE `toll_roads` (
  `road_id` smallint(5) UNSIGNED NOT NULL,
  `road_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `road_price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `toll_road_use`
--

DROP TABLE IF EXISTS `toll_road_use`;
CREATE TABLE `toll_road_use` (
  `id` int(10) UNSIGNED NOT NULL,
  `rental_id` int(10) UNSIGNED NOT NULL,
  `use_date` date NOT NULL COMMENT 'If the customer used toll roads on multiple days, multiple rows should be created, even for a single rental.',
  `road_id` smallint(5) UNSIGNED NOT NULL,
  `number_of_uses` smallint(5) UNSIGNED NOT NULL COMMENT 'Per day.',
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `gov_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'If not Israeli, should be prefixed by a two letter country code (e.g., US12345678).',
  `user_type` tinyint(3) UNSIGNED NOT NULL,
  `first_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `city` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `zip` int(10) UNSIGNED NOT NULL,
  `country` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `passport_photo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Only if country is not Israel. Path to file on disk.',
  `visa_photo` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Only if country is not Israel. Path to file on disk.',
  `drivers_license` int(10) UNSIGNED DEFAULT NULL,
  `drivers_license_validity` date DEFAULT NULL,
  `credit_card` smallint(5) UNSIGNED NOT NULL COMMENT 'Since there''s no MM/YYYY type we use a standard DATETIME type. The DD values will be ignored since credit cards always expire at the end of the month.',
  `credit_card_validity` date NOT NULL,
  `health_declaration_validity` year(4) NOT NULL COMMENT 'Only the year is stored since health declarations are valid until the end of the year.',
  `driver_code` varchar(16) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Code received from Ituran, used by the driver to start the vehicle. Stored as varchar since it may begin with a zero.',
  `token` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Token sent via SMS or email during the login process. Should be cleared once the user logs in.',
  `token_validity` datetime DEFAULT NULL COMMENT 'If NULL then the token is considered invalid.',
  `cookie` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Session cookie used to keep the user logged-in.',
  `cookie_validity` datetime DEFAULT NULL COMMENT 'If NULL then if never expires.',
  `permissions` smallint(5) UNSIGNED NOT NULL COMMENT 'Bitmask: Customer / Administrative driver / Manager / Admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accidents`
--
ALTER TABLE `accidents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accidents_rental_id` (`rental_id`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`car_license_number`),
  ADD KEY `cars_car_type` (`car_type`);

--
-- Indexes for table `car_categories`
--
ALTER TABLE `car_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `car_types`
--
ALTER TABLE `car_types`
  ADD PRIMARY KEY (`car_type_id`),
  ADD KEY `car_types_category` (`category`);

--
-- Indexes for table `configuration`
--
ALTER TABLE `configuration`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `damages`
--
ALTER TABLE `damages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `damages_rental_id` (`rental_id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expenses_rental_id` (`rental_id`),
  ADD KEY `expenses_expense_type` (`expense_type`);

--
-- Indexes for table `expense_types`
--
ALTER TABLE `expense_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faults`
--
ALTER TABLE `faults`
  ADD PRIMARY KEY (`id`),
  ADD KEY `faults_rental_id` (`rental_id`);

--
-- Indexes for table `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fines_rental_id` (`rental_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_rental_id` (`rental_id`),
  ADD KEY `messages_template_id` (`template_id`);

--
-- Indexes for table `message_templates`
--
ALTER TABLE `message_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `orders_customer_id` (`customer_id`),
  ADD KEY `orders_car_license_number` (`car_license_number`),
  ADD KEY `orders_car_category` (`car_category`),
  ADD KEY `orders_driver_id` (`driver_id`),
  ADD KEY `orders_invoice_recipient_id` (`invoice_recipient_id`);

--
-- Indexes for table `photos`
--
ALTER TABLE `photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `photos_rental_id` (`rental_id`),
  ADD KEY `photos_photo_type` (`photo_type`),
  ADD KEY `photos_car_license_number` (`car_license_number`);

--
-- Indexes for table `photo_types`
--
ALTER TABLE `photo_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`rental_id`),
  ADD KEY `rentals_car_license_number` (`car_license_number`),
  ADD KEY `rentals_order_id` (`order_id`),
  ADD KEY `rentals_driver_id` (`driver_id`);

--
-- Indexes for table `toll_roads`
--
ALTER TABLE `toll_roads`
  ADD PRIMARY KEY (`road_id`);

--
-- Indexes for table `toll_road_use`
--
ALTER TABLE `toll_road_use`
  ADD PRIMARY KEY (`id`),
  ADD KEY `toll_road_use_rental_id` (`rental_id`),
  ADD KEY `toll_road_use_road_id` (`road_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `gov_id` (`gov_id`),
  ADD UNIQUE KEY `token` (`token`,`cookie`);
  
--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accidents`
--
ALTER TABLE `accidents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `car_categories`
--
ALTER TABLE `car_categories`
  MODIFY `id` smallint(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faults`
--
ALTER TABLE `faults`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accidents`
--
ALTER TABLE `accidents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fines`
--
ALTER TABLE `fines`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `message_templates`
--
ALTER TABLE `message_templates`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `photos`
--
ALTER TABLE `photos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rentals`
--
ALTER TABLE `rentals`
  MODIFY `rental_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `toll_roads`
--
ALTER TABLE `toll_roads`
  MODIFY `road_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `toll_road_use`
--
ALTER TABLE `toll_road_use`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accidents`
--
ALTER TABLE `accidents`
  ADD CONSTRAINT `accidents_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Constraints for table `car_types`
--
ALTER TABLE `car_types`
  ADD CONSTRAINT `car_types_category` FOREIGN KEY (`category`) REFERENCES `car_categories` (`id`);

--
-- Constraints for table `damages`
--
ALTER TABLE `damages`
  ADD CONSTRAINT `damages_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_expense_type` FOREIGN KEY (`expense_type`) REFERENCES `expense_types` (`id`),
  ADD CONSTRAINT `expenses_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Constraints for table `faults`
--
ALTER TABLE `faults`
  ADD CONSTRAINT `faults_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Constraints for table `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fines_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`),
  ADD CONSTRAINT `messages_template_id` FOREIGN KEY (`template_id`) REFERENCES `message_templates` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_car_category` FOREIGN KEY (`car_category`) REFERENCES `car_categories` (`id`),
  ADD CONSTRAINT `orders_car_license_number` FOREIGN KEY (`car_license_number`) REFERENCES `cars` (`car_license_number`),
  ADD CONSTRAINT `orders_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_invoice_recipient_id` FOREIGN KEY (`invoice_recipient_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `photos`
--
ALTER TABLE `photos`
  ADD CONSTRAINT `photos_car_license_number` FOREIGN KEY (`car_license_number`) REFERENCES `cars` (`car_license_number`),
  ADD CONSTRAINT `photos_photo_type` FOREIGN KEY (`photo_type`) REFERENCES `photo_types` (`id`),
  ADD CONSTRAINT `photos_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Constraints for table `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_car_license_number` FOREIGN KEY (`car_license_number`) REFERENCES `cars` (`car_license_number`),
  ADD CONSTRAINT `rentals_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `rentals_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `toll_road_use`
--
ALTER TABLE `toll_road_use`
  ADD CONSTRAINT `toll_road_use_rental_id` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`),
  ADD CONSTRAINT `toll_road_use_road_id` FOREIGN KEY (`road_id`) REFERENCES `toll_roads` (`road_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
