SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `export_intellix` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `export_intellix` ;

-- -----------------------------------------------------
-- Table `export_intellix`.`produit`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `export_intellix`.`produit` (
  `idproduit` INT NOT NULL AUTO_INCREMENT ,
  `Designation` VARCHAR(255) NOT NULL ,
  `Disponibilite` TINYINT(1)  NOT NULL DEFAULT false ,
  `Seuil` INT NOT NULL DEFAULT 1 ,
  PRIMARY KEY (`idproduit`) ,
  UNIQUE INDEX `Index_designation` (`Designation` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `export_intellix`.`miseajour_produit`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `export_intellix`.`miseajour_produit` (
  `idmiseajour_produit` INT NOT NULL AUTO_INCREMENT ,
  `Date_miseajour` DATETIME NOT NULL ,
  `Total_produit_diponible` INT NULL DEFAULT 0 ,
  `Total_produit_non_diponible` INT NULL DEFAULT 0 ,
  `Total_produits` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`idmiseajour_produit`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `export_intellix`.`Etat_produit`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `export_intellix`.`Etat_produit` (
  `miseajour_produit_idmiseajour_produit` INT NOT NULL ,
  `produit_idproduit` INT NOT NULL ,
  `Etat` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`miseajour_produit_idmiseajour_produit`, `produit_idproduit`) ,
  INDEX `fk_table1_produit1` (`produit_idproduit` ASC) ,
  INDEX `Ind_etat` (`Etat` ASC) ,
  CONSTRAINT `fk_table1_miseajour_produit`
    FOREIGN KEY (`miseajour_produit_idmiseajour_produit` )
    REFERENCES `export_intellix`.`miseajour_produit` (`idmiseajour_produit` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_table1_produit1`
    FOREIGN KEY (`produit_idproduit` )
    REFERENCES `export_intellix`.`produit` (`idproduit` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `export_intellix`.`params_control_miseajour`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `export_intellix`.`params_control_miseajour` (
  `idparams_control_miseajour` INT NOT NULL AUTO_INCREMENT ,
  `designation_param` VARCHAR(255) NOT NULL ,
  `valeur_string` VARCHAR(255) NULL ,
  `valeur_num` VARCHAR(45) NULL ,
  `valeur_bool` TINYINT(1)  NULL ,
  `code_type` VARCHAR(45) NULL ,
  PRIMARY KEY (`idparams_control_miseajour`) )
ENGINE = InnoDB
COMMENT = 'cette table est utilisé pour controler le fonctionnement du mise à jour\ncode_type : s=string,d=decimal,b=boolean\n\nexemple: \nparam: \"space_full\", code_type : b, peut être utilisé pour bloquer la journalisation des mises à jours';


-- -----------------------------------------------------
-- Placeholder table for view `export_intellix`.`view_produit_enrupture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `export_intellix`.`view_produit_enrupture` (`miseajour_produit_idmiseajour_produit` INT, `produit_idproduit` INT, `Etat` INT, `idproduit` INT, `Designation` INT, `Disponibilite` INT, `Seuil` INT, `idmiseajour_produit` INT, `Date_miseajour` INT, `Total_produit_diponible` INT, `Total_produit_non_diponible` INT, `Total_produits` INT);

-- -----------------------------------------------------
-- Placeholder table for view `export_intellix`.`view_produit_nouveau`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `export_intellix`.`view_produit_nouveau` (`miseajour_produit_idmiseajour_produit` INT, `produit_idproduit` INT, `Etat` INT, `idproduit` INT, `Designation` INT, `Disponibilite` INT, `Seuil` INT, `idmiseajour_produit` INT, `Date_miseajour` INT, `Total_produit_diponible` INT, `Total_produit_non_diponible` INT, `Total_produits` INT);

-- -----------------------------------------------------
-- Placeholder table for view `export_intellix`.`view_produit_restock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `export_intellix`.`view_produit_restock` (`miseajour_produit_idmiseajour_produit` INT, `produit_idproduit` INT, `Etat` INT, `idproduit` INT, `Designation` INT, `Disponibilite` INT, `Seuil` INT, `idmiseajour_produit` INT, `Date_miseajour` INT, `Total_produit_diponible` INT, `Total_produit_non_diponible` INT, `Total_produits` INT);

-- -----------------------------------------------------
-- View `export_intellix`.`view_produit_enrupture`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `export_intellix`.`view_produit_enrupture`;
USE `export_intellix`;
CREATE  OR REPLACE VIEW `export_intellix`.`view_produit_enrupture` AS
SELECT * from Etat_produit
 join produit on produit_idproduit=idproduit
 join miseajour_produit on miseajour_produit_idmiseajour_produit=idmiseajour_produit
 where Etat='rupture';

-- -----------------------------------------------------
-- View `export_intellix`.`view_produit_nouveau`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `export_intellix`.`view_produit_nouveau`;
USE `export_intellix`;
CREATE  OR REPLACE VIEW `export_intellix`.`view_produit_nouveau` AS
SELECT * from Etat_produit
 join produit on produit_idproduit=idproduit
 join miseajour_produit on miseajour_produit_idmiseajour_produit=idmiseajour_produit
 where Etat='nouveau';

-- -----------------------------------------------------
-- View `export_intellix`.`view_produit_restock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `export_intellix`.`view_produit_restock`;
USE `export_intellix`;
CREATE  OR REPLACE VIEW `export_intellix`.`view_produit_restock` AS
SELECT * from Etat_produit
 join produit on produit_idproduit=idproduit
 join miseajour_produit on miseajour_produit_idmiseajour_produit=idmiseajour_produit
 where Etat='restock';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
