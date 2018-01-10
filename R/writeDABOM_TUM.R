#' @title Write Tumwater JAGS model
#'
#' @description This writes the overall JAGS model for Tumwater DABOM as a text file. It can then be modified depending on the observations for a particular valid tag list.
#'
#' @author Kevin See
#'
#' @param file_name name (with file path) to save the model as
#'
#' @export
#' @return NULL
#' @examples writeJAGSmodel_TUM()

writeDABOM_TUM = function(file_name = NULL) {

  if(is.null(file_name)) file_name = 'TUM_DABOM.txt'

  model_code = '
model{

  # Set up array detection efficiency priors
  # Icicle
  ICLB0_p ~ dbeta(1,1)
  ICLA0_p ~ dbeta(1,1)
  LEAV_p <- 1 # assume perfect detection
  LNF_p <- 1 # assume perfect detection
  ICMB0_p ~ dbeta(1,1)
  ICMA0_p ~ dbeta(1,1)
  ICUB0_p ~ dbeta(1,1)
  ICUA0_p ~ dbeta(1,1)

  # Peshastin
  PESB0_p ~ dbeta(1,1)
  PESA0_p ~ dbeta(1,1)


  # Chiwaukum
  CHWB0_p ~ dbeta(1,1)
  CHWA0_p ~ dbeta(1,1)

  # Chiwawa
  CHLB0_p ~ dbeta(1,1)
  CHLA0_p ~ dbeta(1,1)

  CHUB0_p ~ dbeta(1,1)
  CHUA0_p ~ dbeta(1,1)

  # Nason
  NALB0_p ~ dbeta(1,1)
  NALA0_p ~ dbeta(1,1)

  NAUB0_p ~ dbeta(1,1)
  NAUA0_p ~ dbeta(1,1)

  # Little Wenatchee
  LWNB0_p ~ dbeta(1,1)
  LWNA0_p ~ dbeta(1,1)

  # White River
  WTLB0_p ~ dbeta(1,1)
  WTLA0_p ~ dbeta(1,1)


  #---------------------------------------------
  # Main branches after Tumwater
  # first row is wild fish, second row is hatchery fish
  main_branch[1, 1:(n_main_branch)] ~ ddirch(main_dirch_vec); # uninformed Dirichlet for probs for going to n_main_branch bins
  main_branch[2, 1:(n_main_branch)] ~ ddirch(main_dirch_vec); # uninformed Dirichlet for probs for going to n_main_branch bins

  # possible values for each branch
  # 1 = Peshastin, 2 = Icicle, 3 = Chiwaukum, 4 = Chiwawa, 5 = Nason, 6 = Little Wenatchee, 7 = White River, 8 = Black box

  for (i in 1:(n_fish)) {
   a[i] ~ dcat( main_branch[origin[i], 1:(n_main_branch)] )
  }
  # expand the dcat variable into a matrix of zeros and ones
  for (i in 1:(n_fish)) {
   for (j in 1:(n_main_branch))	{
    catexp[i,j] <- equals(a[i],j) #equals(x,y) is a test for equality, returns [1,0]
   }
  }

  #---------------------------------------------
  # Peshastin
  #---------------------------------------------
  # only have to worry about observation piece
  for (i in 1:n_fish) {
   # PES site
   Peshastin[i,1] ~ dbern( PESB0_p * catexp[i,1] )
   Peshastin[i,2] ~ dbern( PESA0_p * catexp[i,1] )
  }

  #---------------------------------------------
  # Icicle
  #---------------------------------------------
  for(j in 1:2) {
   phi_icm[j] ~ dbeta(1,1) # probability of making it past ICM
   phi_icu[j] ~ dbeta(1,1) # probability of making it past ICU
  }

  # first row is wild fish, second row is hatchery fish
  icl_branch[1, 1:length(icl_dirch_vec)] ~ ddirch(icl_dirch_vec); # uninformed Dirichlet for probs for going to ICL bins
  icl_branch[2, 1:length(icl_dirch_vec)] ~ ddirch(icl_dirch_vec); # uninformed Dirichlet for probs for going to ICL bins

  # possible values for each branch
  # 1 = LEAV/LNF, 2 = ICM, 3 = Black box


  for (i in 1:n_fish) {
   # ICL
   Icicle[i,1] ~ dbern( ICLB0_p * catexp[i,2] )
   Icicle[i,2] ~ dbern( ICLA0_p * catexp[i,2] )

   a_icl[i] ~ dcat( icl_branch[origin[i], ] )
   for (j in 1:3)	{
    catexp_icl[i,j] <- equals(a_icl[i],j) # equals(x,y) is a test for equality, returns [1,0]
   }

   # LEAV/LNF
   Icicle[i,3] ~ dbern( LEAV_p * catexp_icl[i,1])
   Icicle[i,4] ~ dbern( LNF_p * catexp_icl[i,1])

   # ICM
   # did it make it?
   z_icm[i] ~ dbern(phi_icm[origin[i]] * catexp_icl[i,2])
   # was it observed?
   Icicle[i,5] ~ dbern( ICMB0_p * z_icm[i] )
   Icicle[i,6] ~ dbern( ICMA0_p * z_icm[i] )

   # ICU
   # did it make it?
   z_icu[i] ~ dbern(phi_icu[origin[i]] * z_icm[i])
   # was it observed?
   Icicle[i,7] ~ dbern( ICUB0_p * z_icu[i] )
   Icicle[i,8] ~ dbern( ICUA0_p * z_icu[i] )

  }

  #---------------------------------------------
  # Chiwaukum
  #---------------------------------------------
  # only have to worry about observation piece
  for (i in 1:n_fish) {
   # CHW
   Chiwaukum[i,1] ~ dbern( CHWB0_p * catexp[i,3] )
   Chiwaukum[i,2] ~ dbern( CHWA0_p * catexp[i,3] )
  }

  #---------------------------------------------
  # Chiwawa
  #---------------------------------------------
  for(j in 1:2) {
   phi_chu[j] ~ dbeta(1,1) # probability of making it past CHU
  }

  for (i in 1:n_fish) {

   # CHL
   Chiwawa[i,1] ~ dbern( CHLB0_p * catexp[i,4] )
   Chiwawa[i,2] ~ dbern( CHLA0_p * catexp[i,4] )

   # CHU
   # did it make it?
   z_chu[i] ~ dbern(phi_chu[origin[i]] * catexp[i,4] )
   # was it observed?
   Chiwawa[i,3] ~ dbern( CHUB0_p * z_chu[i] )
   Chiwawa[i,4] ~ dbern( CHUA0_p * z_chu[i] )

  }

  #---------------------------------------------
  # Nason
  #---------------------------------------------
  for(j in 1:2) {
   phi_nau[j] ~ dbeta(1,1)	# probability of making it past NAU
  }

  # make it past the lower array NAL
  for (i in 1:n_fish) {
  # NAL
   Nason[i,1] ~ dbern( NALB0_p * catexp[i,5] )
   Nason[i,2] ~ dbern( NALA0_p * catexp[i,5] )

  # NAU
  # did it make it?
   z_nau[i] ~ dbern(phi_nau[origin[i]] * catexp[i,5] )
  # was it observed?
   Nason[i,3] ~ dbern( NAUB0_p * z_nau[i] )
   Nason[i,4] ~ dbern( NAUA0_p * z_nau[i] )

  }

  #---------------------------------------------
  # Little Wenatchee
  #---------------------------------------------
  # only have to worry about observation piece
  for (i in 1:n_fish) {
   # LWN
   LittleWenatchee[i,1] ~ dbern( LWNB0_p * catexp[i,6] )
   LittleWenatchee[i,2] ~ dbern( LWNA0_p * catexp[i,6] )

  }

  #---------------------------------------------
  # White River
  #---------------------------------------------
  # only have to worry about observation piece
  for (i in 1:n_fish) {
   # WTL
    WhiteRiver[i,1] ~ dbern( WTLB0_p * catexp[i,7] )
    WhiteRiver[i,2] ~ dbern( WTLA0_p * catexp[i,7] )

  }

} # ends model file
'

  # write model as text file
  cat(model_code,
    file = file_name)

  model_file = readLines(file_name)

  writeLines(model_file, file_name)

}