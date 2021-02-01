require_relative 'config_secrets'

# Base
$base_build_config = $base_config_secrets
  .merge({
    xcode_scheme: "TubeService",
    export_options: {},
    output_name: "TubeService",
    
    unit_test_devices: ["iPhone X", "iPad Air"],

    match_type: "adhoc", # adhoc, app-store (don't need "development", use automatic provisioning for development)
    match_git_url: "git@github.com:ridgeview-apps/ridgeview-certs.git",
    match_force_for_new_devices: true,

    app_center_owner_name: "RidgeviewApps",
    app_center_owner_type: "organization",
    app_center_app_name: "TubeService",
    app_center_notify_testers: true, 
    # app_center_destinations: "Beta Testers",
})
    
# Beta
$beta_config = $base_build_config
  .merge($beta_config_secrets)
  .merge({
    main_target_bundle_id: "com.ridgeviewapps.tube-service.beta",
    match_type: "adhoc",
    xcode_configuration: "Adhoc",
    export_method: "ad-hoc",
    shield_prefix: "Beta",
    shield_colour: "blue",
    upload_to_appcenter: true,
    upload_to_testflight: false,
  })
  
# Prod
$prod_config = $base_build_config
  .merge($prod_config_secrets)
  .merge({
    main_target_bundle_id: "com.ridgeviewapps.tube-service",
    match_type: "appstore",
    xcode_configuration: "Release",
    export_method: "app-store",
    upload_to_appcenter: false,
    upload_to_testflight: true,
    export_options: {
      includeBitcode: true,
      compileBitcode: true
    },
  })
  