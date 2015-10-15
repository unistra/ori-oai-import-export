# Ori-Oai-import-export

Scripts d'extraction et d'import de notices depuis des fichiers du SUDOC (unimarc, sérialisation iso2709) vers Ori-oai (Dublin Core UTF-8) :

- extraction des données voulues d'un fichier MARC du SUDOC
- génération des notices en Dublin Core
- ajustement des champs des notices pour respecter la norme (troncature des lignes, suppression de caractères non affichables, format des dates etc...)
- insertion des composantes/UFR dans les notices Dublin Core
- import des notices via le webservice SOAP de Ori-oai 

## Installation
* Pré-requis : Perl 5, Python 3.4+, cpanminus, liblocal-lib-perl, libxml2-utils
* Installer les librairies Perl :
 
    cpanm Perlude MARC::MIR MARC::MIR::Template XML::Tag YAML
    eval $( perl -Mlocal::lib )
    
* Installer le client SOAP pour Python 3 suds-jurko (https://pypi.python.org/pypi/suds-jurko):
 
    pip install suds-jurko
     
* Si l'utilisation de l'iso5426 est nécessaire, cloner : https://github.com/eiro/p5-encode-iso5426


## Configuration
* Indiquer la correspondance des champs (marc/dublin core) dans le fichier config.yml du MARC::MIR::Template unistroai.
* Modifier les fichiers config_"typedoc".ini

## Utilisation
* Simple affichage, sans import de notices dans ORI-OAI : bash go_test.sh config_"typedoc".ini notices_sudoc.tar.gz
* Avec import des notices : bash go.sh config_"typedoc".ini notices_sudoc.tar.gz


