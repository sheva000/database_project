-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `user_ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `email` VARCHAR(60) NULL,
  `phone` VARCHAR(20) NULL,
  `role` ENUM('Guest', 'Host', 'Administrator') NULL,
  `display_name` VARCHAR(60) NULL,
  PRIMARY KEY (`user_ID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Guest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Guest` (
  `guest_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `payment_info` VARCHAR(100) NULL,
  PRIMARY KEY (`guest_ID`),
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_guest`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Host`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Host` (
  `host_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `verification_status` ENUM('Verified', 'Pending', 'Rejected') NULL,
  `display_name` VARCHAR(60) NULL,
  PRIMARY KEY (`host_ID`),
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_host`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Accommodation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Accommodation` (
  `accommodation_ID` INT NOT NULL AUTO_INCREMENT,
  `host_ID` INT NULL,
  `title` VARCHAR(50) NULL,
  `description` TEXT(65535) NULL,
  `address` VARCHAR(255) NULL,
  `price` DECIMAL(10,2) NULL,
  `availability_status` ENUM('Available', 'Booked', 'Unavailable') NULL,
  PRIMARY KEY (`accommodation_ID`),
  INDEX `host_ID_idx` (`host_ID` ASC) VISIBLE,
  CONSTRAINT `FK_host_accommodation`
    FOREIGN KEY (`host_ID`)
    REFERENCES `mydb`.`Host` (`host_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Booking` (
  `booking_ID` INT NOT NULL AUTO_INCREMENT,
  `guest_ID` INT NULL,
  `accommodation_ID` INT NULL,
  `check_in` DATE NULL,
  `check_out` DATE NULL,
  `status` ENUM('Pending', 'Confirmed', 'Cancelled', 'Completed') NULL,
  `total_price` DECIMAL(10,2) NULL,
  PRIMARY KEY (`booking_ID`),
  INDEX `guest_ID_idx` (`guest_ID` ASC) VISIBLE,
  INDEX `accommodation_ID_idx` (`accommodation_ID` ASC) VISIBLE,
  CONSTRAINT `FK_guest_booking`
    FOREIGN KEY (`guest_ID`)
    REFERENCES `mydb`.`Guest` (`guest_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_accommodation_booking`
    FOREIGN KEY (`accommodation_ID`)
    REFERENCES `mydb`.`Accommodation` (`accommodation_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Payment` (
  `payment_ID` INT NOT NULL AUTO_INCREMENT,
  `booking_ID` INT NULL,
  `amount` DECIMAL(10,2) NULL,
  `payment_method` ENUM('Credit Card', 'PayPal', 'Bank Transfer') NULL,
  `payment_status` ENUM('Pending', 'Completed', 'Failed') NULL,
  PRIMARY KEY (`payment_ID`),
  INDEX `booking_ID_idx` (`booking_ID` ASC) VISIBLE,
  CONSTRAINT `FK_booking_payment`
    FOREIGN KEY (`booking_ID`)
    REFERENCES `mydb`.`Booking` (`booking_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Review` (
  `review_ID` INT NOT NULL AUTO_INCREMENT,
  `reviewer_ID` INT NULL,
  `reviewed_user_ID` INT NULL,
  `rating` INT NULL,
  `comment` TEXT(65535) NULL,
  `date` TIMESTAMP NULL,
  PRIMARY KEY (`review_ID`),
  INDEX `reviewer_ID_idx` (`reviewer_ID` ASC) VISIBLE,
  INDEX `reviewed_user_ID_idx` (`reviewed_user_ID` ASC) VISIBLE,
  CONSTRAINT `FK_reviewer_user`
    FOREIGN KEY (`reviewer_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_reviewed_user`
    FOREIGN KEY (`reviewed_user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Message` (
  `message_ID` INT NOT NULL AUTO_INCREMENT,
  `sender_ID` INT NULL,
  `receiver_ID` INT NULL,
  `content` TEXT(65535) NULL,
  `timestamp` TIMESTAMP NULL,
  PRIMARY KEY (`message_ID`),
  INDEX `sender_ID_idx` (`sender_ID` ASC) VISIBLE,
  INDEX `receiver_ID_idx` (`receiver_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_sender`
    FOREIGN KEY (`sender_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_user_receiver`
    FOREIGN KEY (`receiver_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Administrator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Administrator` (
  `admin_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `role_description` TEXT(65535) NULL,
  PRIMARY KEY (`admin_ID`),
  UNIQUE INDEX `admin_ID_UNIQUE` (`admin_ID` ASC) VISIBLE,
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_administrator`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Amenity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Amenity` (
  `amenity_ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `description` TEXT(65535) NULL,
  PRIMARY KEY (`amenity_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Accommodation_Amenity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Accommodation_Amenity` (
  `accommodation_ID` INT NOT NULL,
  `amenity_ID` INT NOT NULL,
  INDEX `accommodation_ID_idx` (`accommodation_ID` ASC) INVISIBLE,
  INDEX `amenity_ID_idx` (`amenity_ID` ASC) VISIBLE,
  PRIMARY KEY (`accommodation_ID`, `amenity_ID`),
  CONSTRAINT `FK_accommodation_amenity`
    FOREIGN KEY (`accommodation_ID`)
    REFERENCES `mydb`.`Accommodation` (`accommodation_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_amenity_accommodation`
    FOREIGN KEY (`amenity_ID`)
    REFERENCES `mydb`.`Amenity` (`amenity_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Commission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Commission` (
  `commission_ID` INT NOT NULL AUTO_INCREMENT,
  `host_ID` INT NULL,
  `booking_ID` INT NULL,
  `commission_percentage` DECIMAL(5,2) NULL,
  `commission_amount` DECIMAL(10,2),
  PRIMARY KEY (`commission_ID`),
  INDEX `host_ID_idx` (`host_ID` ASC) VISIBLE,
  INDEX `booking_ID_idx` (`booking_ID` ASC) VISIBLE,
  CONSTRAINT `FK_host_commission`
    FOREIGN KEY (`host_ID`)
    REFERENCES `mydb`.`Host` (`host_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_booking_commission`
    FOREIGN KEY (`booking_ID`)
    REFERENCES `mydb`.`Booking` (`booking_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Availability`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Availability` (
  `availability_ID` INT NOT NULL,
  `accommodation_ID` INT NULL,
  `date` DATE NULL,
  `status` ENUM('Available', 'Booked', 'Unavailable') NULL,
  PRIMARY KEY (`availability_ID`),
  INDEX `accommodation_ID_idx` (`accommodation_ID` ASC) VISIBLE,
  CONSTRAINT `FK_accommodation_availability`
    FOREIGN KEY (`accommodation_ID`)
    REFERENCES `mydb`.`Accommodation` (`accommodation_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Dispute`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Dispute` (
  `dispute_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `booking_ID` INT NULL,
  `description` TEXT(65535) NULL,
  `status` ENUM('Open', 'Resolved', 'Rejected') NULL,
  PRIMARY KEY (`dispute_ID`),
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  INDEX `booking_ID_idx` (`booking_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_dispute`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_booking_dispute`
    FOREIGN KEY (`booking_ID`)
    REFERENCES `mydb`.`Booking` (`booking_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Country` (
  `country_ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`country_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`City`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`City` (
  `city_ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `country_ID` INT NULL,
  PRIMARY KEY (`city_ID`),
  INDEX `country_ID_idx` (`country_ID` ASC) VISIBLE,
  CONSTRAINT `FK_country_city`
    FOREIGN KEY (`country_ID`)
    REFERENCES `mydb`.`Country` (`country_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Discount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Discount` (
  `discount_ID` INT NOT NULL AUTO_INCREMENT,
  `booking_ID` INT NOT NULL,
  `payment_ID` INT NOT NULL,
  `discount_percentage` DECIMAL(5,2) NOT NULL,
  `expiration_date` DATE NULL,
  PRIMARY KEY (`discount_ID`),
  INDEX `booking_ID_idx` (`booking_ID` ASC) VISIBLE,
  INDEX `payment_ID_idx` (`payment_ID` ASC) VISIBLE,
  CONSTRAINT `FK_discount_booking`
    FOREIGN KEY (`booking_ID`)
    REFERENCES `mydb`.`Booking` (`booking_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_discount_payment`
    FOREIGN KEY (`payment_ID`)
    REFERENCES `mydb`.`Payment` (`payment_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Complaint`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Complaint` (
  `complaint_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `target_ID` INT NULL,
  `description` TEXT(65535) NULL,
  `status` ENUM('Open', 'Resolved', 'Rejected') NULL,
  `date_filed` TIMESTAMP NULL,
  PRIMARY KEY (`complaint_ID`),
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  INDEX `target_ID_idx` (`target_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_complaint`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_target_user_complaint`
    FOREIGN KEY (`target_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Blacklist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Blacklist` (
  `blacklist_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `reason` TEXT(65535) NULL,
  `date_added` DATE NULL,
  PRIMARY KEY (`blacklist_ID`),
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_blacklist`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Support_Ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Support_Ticket` (
  `ticket_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NULL,
  `subject` VARCHAR(255) NULL,
  `status` ENUM('Open', 'Resolved', 'Closed') NULL,
  `created_at` DATE NULL,
  PRIMARY KEY (`ticket_ID`),
  INDEX `user_ID_idx` (`user_ID` ASC) VISIBLE,
  CONSTRAINT `FK_user_support_ticket`
    FOREIGN KEY (`user_ID`)
    REFERENCES `mydb`.`User` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
