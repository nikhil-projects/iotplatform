-- MySQL Script generated by MySQL Workbench
-- Ned 14 Sij 2018 14:53:13
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema iotplatform
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `iotplatform` ;

-- -----------------------------------------------------
-- Schema iotplatform
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `iotplatform` DEFAULT CHARACTER SET utf8 ;
USE `iotplatform` ;

-- -----------------------------------------------------
-- Table `iotplatform`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`user` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(90) NOT NULL,
  `password` VARCHAR(90) NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `remember_token` VARCHAR(300) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iotplatform`.`device`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`device` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`device` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `mac_address` VARCHAR(200) NULL,
  `location` VARCHAR(300) NULL,
  `notes` VARCHAR(2000) NULL,
  `last_check` DATETIME NULL,
  `read_time` INT NULL,
  `api_key` VARCHAR(45) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  PRIMARY KEY (`id`),
  INDEX `fk_devices_users1_idx` (`user_id` ASC),
  CONSTRAINT `fk_devices_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iotplatform`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iotplatform`.`device_field`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`device_field` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`device_field` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(45) NOT NULL,
  `device_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_device_fields_devices_idx` (`device_id` ASC),
  CONSTRAINT `fk_device_fields_devices`
    FOREIGN KEY (`device_id`)
    REFERENCES `iotplatform`.`device` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iotplatform`.`data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`data` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`data` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `value` DECIMAL(12,2) NOT NULL,
  `datetime` DATETIME NOT NULL,
  `device_field_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_data_device_fields1_idx` (`device_field_id` ASC),
  CONSTRAINT `fk_data_device_fields1`
    FOREIGN KEY (`device_field_id`)
    REFERENCES `iotplatform`.`device_field` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iotplatform`.`trigger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`trigger` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`trigger` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `max_value` DECIMAL(12,2) NOT NULL,
  `min_value` DECIMAL(12,2) NOT NULL,
  `email` VARCHAR(90) NULL,
  `webhook_url` VARCHAR(200) NULL,
  `device_field_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_triggers_device_fields1_idx` (`device_field_id` ASC),
  CONSTRAINT `fk_triggers_device_fields1`
    FOREIGN KEY (`device_field_id`)
    REFERENCES `iotplatform`.`device_field` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iotplatform`.`chart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`chart` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`chart` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `public` TINYINT(1) NOT NULL DEFAULT 0,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_charts_users1_idx` (`user_id` ASC),
  CONSTRAINT `fk_charts_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iotplatform`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iotplatform`.`chart_field`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iotplatform`.`chart_field` ;

CREATE TABLE IF NOT EXISTS `iotplatform`.`chart_field` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `chart_id` INT NOT NULL,
  `device_field_id` INT NOT NULL,
  INDEX `fk_charts_has_device_fields_device_fields1_idx` (`device_field_id` ASC),
  INDEX `fk_charts_has_device_fields_charts1_idx` (`chart_id` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  CONSTRAINT `fk_charts_has_device_fields_charts1`
    FOREIGN KEY (`chart_id`)
    REFERENCES `iotplatform`.`chart` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_charts_has_device_fields_device_fields1`
    FOREIGN KEY (`device_field_id`)
    REFERENCES `iotplatform`.`device_field` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;