#!/usr/bin/env bash

echo -e ""
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e ""

# Check config directory existance.
echo -e ""
echo -e "${BLUE}Verifying config directory setup.${NC}"
if [ ! -d "$CONFIG_DIR" ]; then
  echo -e ""
  echo -e "${ORANGE}Your config directory does not exist yet.${NC}"
  while true; do
    echo ''
    read -p "Would you like to create it? [y/N] " yn
    case $yn in
        [Yy]* )
          mkdir $CONFIG_DIR
          echo -e ""
          echo -e "${LIGHT_GREEN}Config directory $CONFIG_DIR created.${NC}"
          break;;
        [Nn]* )
          echo -e "${LIGHT_CYAN}Config directory not created.${NC}"
          exit;;
        "" ) exit;;
        * ) echo -e "${ORANGE}Please answer yes or no.${NC}";;
    esac
  done
fi
echo -e ""
echo -e "${GREEN}Config directory... OK!${NC}"

echo -e ""
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e ""

# Load the config file.
echo -e "${BLUE}Verifying environment config settings.${NC}"
if [ ! -f "$CONFIG_DIR/env_config.cfg" ]; then
  echo -e ""
  echo -e "${ORANGE}There is no config file for the environment.${NC}"
  while true; do
    echo ''
    read -p "Would you like to create it? [y/N] " yn
    case $yn in
      [Yy]* )
        while true; do
          echo -e ""
          echo -e "Which environment are you building?"
          echo -e ""
          echo -e "\t1) Dev"
          echo -e "\t2) Recette"
          echo -e "\t3) Preprod"
          echo -e "\t4) Prod"
          read -p "Environment: " env_name
          case $env_name in
            ""|"q" ) exit;;
            1|2|3|4)
              if [ $env_name -eq 1 ]; then
                ENV_NAME=dev
                elif [ $env_name -eq 2 ]; then
                ENV_NAME=recette
                elif [ $env_name -eq 3 ]; then
                ENV_NAME=preprod
                elif [ $env_name -eq 4 ]; then
                ENV_NAME=prod
              fi
              break;
            ;;
            * )
              echo -e ""
              echo -e "${ORANGE}Please select one of the listed options.${NC}"
              ;;
            esac
        done
        while true; do
          echo -e ""
          echo -e "Which mode should be used?"
          echo -e ""
          echo -e "\t1) Install"
          echo -e "\t2) Update"
          read -p "Mode: " build_mode
          case $build_mode in
            ""|"q" ) exit;;
            1|2)
              if [ $env_name -eq 1 ]; then
                BUILD_MODE=install
                elif [ $env_name -eq 2 ]; then
                BUILD_MODE=update
              fi
              break;
            ;;
            * )
              echo -e ""
              echo -e "${ORANGE}Please select one of the listed options.${NC}"
              ;;
            esac
        done
        # Export the config in a file.
        export BUILD_MODE ENV_NAME
        TEMPLATE=$(<$TEMPLATES_DIR/env_config.conf)
        echo "$TEMPLATE" | envsubst > $CONFIG_DIR/env_config.cfg

        break;;
      [Nn]* )
        echo -e "${LIGHT_CYAN}Config file not created.${NC}"
        exit;;
      "" ) exit;;
      * )
        echo -e ""
        echo -e "${ORANGE}Please answer yes or no.${NC}"
        ;;
    esac
  done
fi

echo -e ""
echo "Loading config settings..." >&2
source $CONFIG_DIR/env_config.cfg
if [ -r $CONFIG_DIR/.env_config.cfg ]; then
  echo -e ""
  echo -e "${ORANGE}An overriden settings file exists and is loaded.${NC}"
  source $CONFIG_DIR/.env_config.cfg
fi
echo -e ""
echo -e "${GREEN}Config settings... Loaded!${NC}"

echo -e ""
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e ""
