-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8 ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`proveidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`proveidor` (
  `id_proveidor` INT(5) NOT NULL AUTO_INCREMENT,
  `NIF_proveidor` VARCHAR(12) NULL,
  `nom` VARCHAR(45) NULL,
  `adreca` VARCHAR(100) NULL,
  `telefon` INT(13) NULL,
  `fax` INT(13) NULL,
  PRIMARY KEY (`id_proveidor`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `NIF_UNIQUE` ON `optica`.`proveidor` (`NIF_proveidor` ASC) VISIBLE;

INSERT INTO `proveidor` (`NIF_proveidor`, `nom`, `adreca`, `telefon`, `fax`) 
VALUES ('73595702A', 'proveidor1', 'adreça_proveidor1', 600000000, 900000000);	
INSERT INTO `proveidor` (`NIF_proveidor`, `nom`, `adreca`, `telefon`, `fax`) 
VALUES ('73595702B', 'proveidor2', 'adreça_proveidor2', 600000000, 900000000);	
INSERT INTO `proveidor` (`NIF_proveidor`, `nom`, `adreca`, `telefon`, `fax`) 
VALUES ('73595702C', 'proveidor3', 'adreça_proveidor3', 600000000, 900000000);	

-- -----------------------------------------------------
-- Table `optica`.`marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`marca` (
  `id_marca` INT(5) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(30) NULL,
  `proveidor_id` INT(5) NOT NULL,
  PRIMARY KEY (`id_marca`),
  CONSTRAINT `fk_marca_proveidor1`
    FOREIGN KEY (`proveidor_id`)
    REFERENCES `optica`.`proveidor` (`id_proveidor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_marca_proveidor1_idx` ON `optica`.`marca` (`proveidor_id` ASC) VISIBLE;

INSERT INTO `marca` (`nom`, `proveidor_id`) VALUES ('Hugo Boss', 1);
INSERT INTO `marca` (`nom`, `proveidor_id`) VALUES ('Ray-Ban', 1);
INSERT INTO `marca` (`nom`, `proveidor_id`) VALUES ('Emporio Armani', 2);
INSERT INTO `marca` (`nom`, `proveidor_id`) VALUES ('Ralph Lauren', 3);
INSERT INTO `marca` (`nom`, `proveidor_id`) VALUES ('E. Z.', 3);

-- -----------------------------------------------------
-- Table `optica`.`ulleres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`ulleres` (
  `id_ulleres` INT(10) NOT NULL AUTO_INCREMENT,
  `marca_id` INT(5) NOT NULL,
  `color_vidre` VARCHAR(15) NULL,
  `tipus_montura` ENUM('metàl·lica', 'flotant', 'pasta') NULL,
  `color_montura` VARCHAR(15) NULL,
  `preu` FLOAT(6,2) NULL,
  PRIMARY KEY (`id_ulleres`),
  CONSTRAINT `fk_ulleres_marca1`
    FOREIGN KEY (`marca_id`)
    REFERENCES `optica`.`marca` (`id_marca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_ulleres_marca1_idx` ON `optica`.`ulleres` (`marca_id` ASC) VISIBLE;

INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (1, 'transparent', 'flotant', 'negre', 120.55);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (2, 'negre', 'pasta', 'gris', 300.25);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (2, 'negre', 'metàl·lica', 'gris', 400.19);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (2, 'blau', 'pasta', 'negre', 70.24);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (3, 'transparent', 'metàl·lica', 'negre', 475.10);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (4, 'transparent', 'flotant', 'negre', 390.45);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (4, 'transparent', 'pasta', 'gris', 99.99);
INSERT INTO `ulleres` (`marca_id`, `color_vidre`, `tipus_montura`, `color_montura`, `preu`) 
VALUES (5, 'negre', 'metàl·lica', 'negre', 79.98);

-- -----------------------------------------------------
-- Table `optica`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`clients` (
  `id_client` INT(9) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  `adreca` VARCHAR(100) NULL,
  `telefon` INT(13) NULL,
  `email` VARCHAR(40) NULL,
  `data_registre` DATE NOT NULL,
  `referral` INT(9) NULL,
  PRIMARY KEY (`id_client`),
  CONSTRAINT `referral`
    FOREIGN KEY (`referral`)
    REFERENCES `optica`.`clients` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO `clients` (`nom`, `adreca`, `telefon`, `email`, `data_registre`, `referral`)
VALUES ('client1', 'adreça_client1', 600000000, 'email_client1', '2022-06-27', NULL);
INSERT INTO `clients` (`nom`, `adreca`, `telefon`, `email`, `data_registre`, `referral`)
VALUES ('client2', 'adreça_client2', 600000000, 'email_client2', '2022-06-28', 1);
INSERT INTO `clients` (`nom`, `adreca`, `telefon`, `email`, `data_registre`, `referral`)
VALUES ('client3', 'adreça_client3', 600000000, 'email_client3', '2021-06-29', 1);
INSERT INTO `clients` (`nom`, `adreca`, `telefon`, `email`, `data_registre`, `referral`)
VALUES ('client4', 'adreça_client4', 600000000, 'email_client4', '2021-08-28', 2);

-- -----------------------------------------------------
-- Table `optica`.`venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`venda` (
  `id_venda` INT(10) NOT NULL AUTO_INCREMENT,
  `ulleres_id` INT(10) NOT NULL,
  `data_venda` DATE NULL,
  `client_id` INT(9) NOT NULL,
  `empleat` VARCHAR(45) NULL,
  PRIMARY KEY (`id_venda`),
  CONSTRAINT `fk_venda_clients1`
    FOREIGN KEY (`client_id`)
    REFERENCES `optica`.`clients` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venda_ulleres1`
    FOREIGN KEY (`ulleres_id`)
    REFERENCES `optica`.`ulleres` (`id_ulleres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_venda_clients1_idx` ON `optica`.`venda` (`client_id` ASC) VISIBLE;

CREATE INDEX `fk_venda_ulleres1_idx` ON `optica`.`venda` (`ulleres_id` ASC) VISIBLE;

CREATE UNIQUE INDEX `ulleres_id_UNIQUE` ON `optica`.`venda` (`ulleres_id` ASC) VISIBLE;

INSERT INTO `venda` (`ulleres_id`, `data_venda`, `client_id`, `empleat`)
VALUES (1, '2022-07-03', 1, 'Ernest');
INSERT INTO `venda` (`ulleres_id`, `data_venda`, `client_id`, `empleat`)
VALUES (3, '2022-07-04', 2, 'Joan');
INSERT INTO `venda` (`ulleres_id`, `data_venda`, `client_id`, `empleat`)
VALUES (4, '2022-07-04', 2, 'Ernest');
INSERT INTO `venda` (`ulleres_id`, `data_venda`, `client_id`, `empleat`)
VALUES (5, '2022-07-05', 3, 'Ernest');
INSERT INTO `venda` (`ulleres_id`, `data_venda`, `client_id`, `empleat`)
VALUES (6, '2022-07-05', 4, 'Joan');
INSERT INTO `venda` (`ulleres_id`, `data_venda`, `client_id`, `empleat`)
VALUES (7, '2022-07-07', 4, 'Ernest');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
