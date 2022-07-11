-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provincia` (
  `id_provincia` INT(2) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(25) NULL,
  PRIMARY KEY (`id_provincia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`localitat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`localitat` (
  `id_localitat` INT(4) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(30) NULL,
  `provincia_id` INT(2) NOT NULL,
  PRIMARY KEY (`id_localitat`, `provincia_id`),
  CONSTRAINT `fk_localitat_provincia`
    FOREIGN KEY (`provincia_id`)
    REFERENCES `pizzeria`.`provincia` (`id_provincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_localitat_provincia_idx` ON `pizzeria`.`localitat` (`provincia_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `pizzeria`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`client` (
  `id_client` INT(9) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(15) NULL,
  `cognoms` VARCHAR(30) NULL,
  `adreca` VARCHAR(100) NULL,
  `codi_postal` VARCHAR(5) NULL,
  `telefon` VARCHAR(13) NULL,
  `localitat_id` INT(4) NOT NULL,
  PRIMARY KEY (`id_client`, `localitat_id`),
  CONSTRAINT `fk_client_localitat1`
    FOREIGN KEY (`localitat_id`)
    REFERENCES `pizzeria`.`localitat` (`id_localitat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_client_localitat1_idx` ON `pizzeria`.`client` (`localitat_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `pizzeria`.`botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`botiga` (
  `id_botiga` INT(4) NOT NULL AUTO_INCREMENT,
  `adreca` VARCHAR(100) NULL,
  `codi_postal` VARCHAR(5) NULL,
  `localitat_id` INT(4) NOT NULL,
  PRIMARY KEY (`id_botiga`, `localitat_id`),
  CONSTRAINT `fk_botiga_localitat1`
    FOREIGN KEY (`localitat_id`)
    REFERENCES `pizzeria`.`localitat` (`id_localitat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_botiga_localitat1_idx` ON `pizzeria`.`botiga` (`localitat_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `pizzeria`.`empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`empleat` (
  `id_empleat` INT(6) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(15) NOT NULL,
  `cognoms` VARCHAR(30) NOT NULL,
  `NIF` VARCHAR(9) NOT NULL,
  `telefon` VARCHAR(13) NULL,
  `carrec` ENUM("cuiner", "repartidor") NOT NULL,
  `botiga_id` INT(4) NOT NULL,
  PRIMARY KEY (`id_empleat`, `botiga_id`),
  CONSTRAINT `fk_empleat_botiga1`
    FOREIGN KEY (`botiga_id`)
    REFERENCES `pizzeria`.`botiga` (`id_botiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `NIF_UNIQUE` ON `pizzeria`.`empleat` (`NIF` ASC) VISIBLE;

CREATE INDEX `fk_empleat_botiga1_idx` ON `pizzeria`.`empleat` (`botiga_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `pizzeria`.`comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comanda` (
  `id_comanda` INT(12) NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL,
  `tipus` ENUM("domicili", "botiga") NULL,
  `client_id` INT(9) NOT NULL,
  `empleat_id` INT(6) NULL,
  `botiga_id` INT(4) NOT NULL,
  `data_hora_recollida` DATETIME NULL,
  PRIMARY KEY (`id_comanda`, `botiga_id`, `client_id`),
  CONSTRAINT `fk_comanda_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `pizzeria`.`client` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comanda_empleat1`
    FOREIGN KEY (`empleat_id`)
    REFERENCES `pizzeria`.`empleat` (`id_empleat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comanda_botiga1`
    FOREIGN KEY (`botiga_id`)
    REFERENCES `pizzeria`.`botiga` (`id_botiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_comanda_client1_idx` ON `pizzeria`.`comanda` (`client_id` ASC) VISIBLE;

CREATE INDEX `fk_comanda_empleat1_idx` ON `pizzeria`.`comanda` (`empleat_id` ASC) VISIBLE;

CREATE INDEX `fk_comanda_botiga1_idx` ON `pizzeria`.`comanda` (`botiga_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `pizzeria`.`categoria_pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categoria_pizza` (
  `id_categoria_pizza` INT(3) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(30) NULL,
  PRIMARY KEY (`id_categoria_pizza`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`producte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`producte` (
  `id_producte` INT(6) NOT NULL AUTO_INCREMENT,
  `tipus` ENUM("pizza", "hamburguesa", "beguda") NULL,
  `categoria_pizza_id` INT(3) NULL,
  `nom` VARCHAR(20) NULL,
  `descripcio` TINYTEXT NULL,
  `imatge` VARCHAR(30) NULL,
  `preu` FLOAT(6,2) NULL,
  PRIMARY KEY (`id_producte`),
  CONSTRAINT `fk_producte_categoria_pizza1`
    FOREIGN KEY (`categoria_pizza_id`)
    REFERENCES `pizzeria`.`categoria_pizza` (`id_categoria_pizza`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_producte_categoria_pizza1_idx` ON `pizzeria`.`producte` (`categoria_pizza_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `pizzeria`.`comandes_productes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comandes_productes` (
  `comanda_id` INT(12) NOT NULL,
  `producte_id` INT(6) NOT NULL,
  PRIMARY KEY (`comanda_id`, `producte_id`),
  CONSTRAINT `fk_comandes_productes_comanda1`
    FOREIGN KEY (`comanda_id`)
    REFERENCES `pizzeria`.`comanda` (`id_comanda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comandes_productes_producte1`
    FOREIGN KEY (`producte_id`)
    REFERENCES `pizzeria`.`producte` (`id_producte`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_comandes_productes_comanda1_idx` ON `pizzeria`.`comandes_productes` (`comanda_id` ASC) VISIBLE;

CREATE INDEX `fk_comandes_productes_producte1_idx` ON `pizzeria`.`comandes_productes` (`producte_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
