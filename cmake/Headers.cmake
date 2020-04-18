#
# The following includes include definitions generated
# during `mulle-sde update`. Don't edit those files. They are
# overwritten frequently.
#
# === MULLE-SDE START ===

include( _Headers)

# === MULLE-SDE END ===
#

# keep headers to install separate to make last minute changes
set( INSTALL_PUBLIC_HEADERS ${PUBLIC_HEADERS}
${PUBLIC_GENERATED_HEADERS}
)

#
# Do not install generated private headers and include-private.h
# which aren't valid outside of the project scope.
#
set( INSTALL_PRIVATE_HEADERS ${PRIVATE_HEADERS})
if( INSTALL_PRIVATE_HEADERS)
   list( REMOVE_ITEM INSTALL_PRIVATE_HEADERS "src/import-private.h")
   list( REMOVE_ITEM INSTALL_PRIVATE_HEADERS "src/include-private.h")
endif()
#
# You can put more source and resource file definitions here.
#
