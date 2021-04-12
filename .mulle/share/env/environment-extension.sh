#
# Reset to empty
#
export MULLE_SDE_REFLECT_CALLBACKS="sourcetree:source"


#
# Used by `mulle-match find` to speed up the search.
#
export MULLE_MATCH_FILENAMES="config:*.h:*.inc:*.c:*.m:*.aam:CMakeLists.txt:*.cmake"


#
# Used by `mulle-match find` to locate files
#
export MULLE_MATCH_PATH=".mulle/etc/sourcetree/config:${PROJECT_SOURCE_DIR}:CMakeLists.txt:cmake"


#
# Used by `mulle-match find` to ignore boring subdirectories like .git
#
export MULLE_MATCH_IGNORE_PATH=""


#
# If you are really basing on MulleObjC you need this startup lib
#
export PREFERRED_STARTUP_LIBRARY="MulleObjC-startup"


#
# tell mulle-sde to keep files protected from read/write changes
#
export MULLE_SDE_PROTECT_PATH="cmake/share"


