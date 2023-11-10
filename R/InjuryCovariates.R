#' @title InjuryCovariates
#'
#' @description
#' Define covariates from whale injury narratives based on presence or absence of key words or phrases
#' used to predict health outcomes. 'Narratives' (case sensitive) should be in a wide-form data frame
#' in column of same name. Append covariates to data frame using function InjuryCovariates(). Resulting
#' data frame is used with Random Forest classification trees to predict health status of whales involved in
#' entanglements or vessel strikes. Package includes example data frame "WhaleData"
#'
#' @usage InjuryCovariates(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' # append injury covariates to WhaleData
#'
#' WhaleDataCovs <- InjuryCovariates(WhaleData)
#'
#' head(WhaleDataCovs)
#'
#' # show barplot of injury covariates by health status
#'  barplotCovariates(WhaleDataCovs)
#'
#' @export
#'

InjuryCovariates = function(df) {

# Covariates defined below, starting with covariate = 'mobility.limited'
# Multiple words/phrases may be pooled into a single covariate, e.g. the covariate 'decline'
# includes narrative words/phrases 'cyamid', 'whale lice', 'emaciation', 'skin discoloration', etc.
# Covariate string searches use function 'grepl' and may be abbreviated to accommodate different
# states of same word/phrase/meaning. For example, an emaciated whale may include narrative
# references to: 'emacatied', 'emaciation'. Thus, the string 'emaciat' is used with function grepl.
# Covariate misspellings (e.g. 'propeller' vs 'propellar') are coded generically ('propell') to capture
# all occurrences.

# Multiple conditions are identified using string wildcards with grepl() function:
# Narratives including both 'flukes' and 'missing' are identified using grepl("missing.*fluke|fluke.*missing))
# while phrases as 'partially disentangled' and 'partial disentanglement' are handled by grepl("partial.*disentangl)

# Evidence the whale was mobility.limited or had limited mobility resulting from an entanglement?

    mobility.limited = paste(c("anchor", "difficultly spending time at surface", "exhausted", "hog", "motionless",
                    "mobility","unable to move","stationary whale", "entrap", "not using flukes", "inability to",
                    "whale was stationary", "animal was stationary", "stationary animal", "forward progress",
                    "weighted","using flippers only", "could not freely swim", "docile", "ability to", "unable to dive",
                    "bobbing up and down to breathe"), collapse="|")

    mobility.limited = grepl(mobility.limited, df$Narrative, ignore.case=TRUE)

    mobility.limited = as.numeric(lapply(mobility.limited, as.numeric))

# Was a calf, juvenile or lactating mother involved?
    calf.juv = paste(c("calf","juvenile","young","dependent"), collapse="|")
    calf.juv = grepl(calf.juv, df$Narrative, ignore.case=TRUE)
    calf.juv = as.numeric(lapply(calf.juv, as.numeric))

# Evidence of constricting entanglement?
    constricting = paste(c("abcess", "abscess", "artery", "arterial", "constricting", "deep cut", "imbed", "tight", "cutting", "indent",
                        "impression", "embed", "pinn", "twisted", "necrotic", "amputat", "missing.*fluke", "not using", "fluke.*missing",
                        "severed", "tightly wrapped", "tight wrap", "wrapped tight"), collapse="|")

    constricting = grepl(constricting, df$Narrative, ignore.case=TRUE)
    constricting = as.numeric(lapply(constricting, as.numeric))

# Some narratives reference 'constricting' in the negative, e.g. "no constricting wraps". Presence of the word 'constricting'
# in these cases would erroneously lead to coding the covariate 'constricting' as present in the narrative. Identify those cases
# where 'constricting' is used in the negative and reassign those cases with a 'constricting' value=0.

  not.constricting = paste(c("no constricting wraps", "unlikely to become constricting", "loose or constricting",
                             "constricting or loose", "doesn't look constricting", "non constricting",
                             "non-constricting", "did not appear to be embedded or constricting",
                             "Unable to confirm if wraps constricting"), collapse="|")

  not.constricting.ind = grep(not.constricting, df$Narrative, ignore.case=TRUE)

  constricting[not.constricting.ind]=0

# Evidence of a health decline?
 decline = paste(c(" abnormal", "bad health", "chronic", "deteriorat", "fair cond", "fair body", "body condition fair", "compromise",
                   "scoliosis", "deform", "cyamid", "lice", "lethargic", "lesion", "discolor", "diatom", "parasit", "poor cond",
                   "poor health", "poor body", "poor over","poor skin","rake","discolored skin","skin discolor",
                   "slough", "thin ", "emaciat", "malnourish", "underweight", "unhealthy", "starv"), collapse="|")

 decline = grepl(decline, df$Narrative, ignore.case=TRUE)
 decline = as.numeric(lapply(decline, as.numeric))

# 'Extensive or Severe' case resulting from entanglement or vessel strike?
 extensive.severe = paste(c("amputat", "extensive", "substantial", "massive", "major", "distorted",
                             "missing fluke", "severe", "severed", "significant", "badly"), collapse="|")
     extensive.severe = grepl(extensive.severe, df$Narrative, ignore.case=TRUE)
      extensive.severe = as.numeric(lapply(extensive.severe, as.numeric))

# Did injury involve fluke or peduncle area?
 fluke.peduncle = paste(c("fluke", "peduncle", "tail"), collapse="|")
      fluke.peduncle = grepl(fluke.peduncle, df$Narrative, ignore.case=TRUE)
       fluke.peduncle = as.numeric(lapply(fluke.peduncle, as.numeric))

#  Evidence that whale is gear-free after initial sighting? Or is expected to shed loose gear?
 gear.free = paste(c("gear free", "shed", "gear-free", "no gear present", "no gear attached", "complete removal of gear",
                      "free of gear", "self.*release", "disentangled", "removal of all gear",
                        "no gear remaining", "all gear removed", "broke free", "removed all gear",
                         "removal of all gear", "completely removed", "cut the gear", "removed lines",
                           "line removed", "removed all", "removed gear", "freeing it",
                             "confirmed to be free of any entanglements", " free of an active entanglement",
                               "complete gear removal"), collapse="|")

 gear.free = grepl(gear.free, df$Narrative, ignore.case=TRUE)
  gear.free = as.numeric(lapply(gear.free, as.numeric))

# Injury involved head, rostrum, or mouth?
 head = paste(c("head", "baleen", "mouth", "rostrum", "lips", " lip ", "jaw", "blowhole", "nares", "gape", "throat"), collapse="|")
      head = grepl(head, df$Narrative, ignore.case=TRUE)
       head = as.numeric(lapply(head, as.numeric))

# Deep laceration?
 laceration.deep = paste(c("deep.*laceration", "laceration.*deep", "muscle", "laceration.*blubber",
                              "blubber.*laceration", "laceration.*artery", "artery.*laceration",
                              "laceration.*arteri", "arteri.*laceration", "laceration.*massive",
                              "massive.*laceration", "laceration.*penetrat", "penetrat.*laceration",
                              "laceration.*necrotic", "necrotic.*laceration", "large.*laceration",
                              "laceration.*large", "laceration.*propell", "propell.*laceration",
                              "deep.*propel", "propel.*deep", "bleeding", "bone", "open wound",
                              "major laceration", "massive", "pool of blood"), collapse="|")

 laceration.deep = grepl(laceration.deep, df$Narrative, ignore.case=TRUE)
 laceration.deep = as.numeric(lapply(laceration.deep, as.numeric))

# Shallow laceration?
 laceration.shallow = paste(c("shallow.*laceration", "laceration.*shallow", "minor.*laceration",
                       "laceration.*minor", "superficial.*laceration", "laceration.*superficial", "heal.*laceration",
                       "laceration.*heal", "small.*laceration","laceration.*small", "superficial prop", "superficial skeg",
                       "small.*wounds", "no.*blood", "or visible injuries", "no visible wounds", "no visible injur",
                       "no.inj", "not inj", "no noticeable inj", "no discernable inj", "no apparent inj", "wound free", "uninj",
                       "no sign of injury", "unharmed"), collapse="|")

 laceration.shallow = grepl(laceration.shallow, df$Narrative, ignore.case=TRUE)
 laceration.shallow = as.numeric(lapply(laceration.shallow, as.numeric))

# Deep vs Shallow laceration is hierarchical. A whale with both gets coded for a deep laceration.
# A whale with a healing laceration may have initially had a deep laceration. It is coded as deep.
# index cases with deep lacerations and re-code previously-indexed shallow lacerations as zeroes

 deep.lac.pos = which(laceration.deep==1)
 laceration.shallow[deep.lac.pos] = 0

# Evidence whale is | was healthy | healing | recovering?
 healing = paste(c("behavior appeared normal", "healthy", "healing","healed","healthy.*resight","resight.*healthy", "good body condition", "good condition", "good health", "minor",
                     "injury free", "full migration, returning with a healthy calf", "or visible injuries", "no visible wounds", "no visible injur",
                   "no.inj", "not inj", "no noticeable inj", "no discernable inj", "no apparent inj", "wound free", "uninj",
                   "no sign of injury", "unharmed", "did not observe fresh blood or injuries"), collapse="|")

 healing = grepl(healing, df$Narrative, ignore.case=TRUE)
 healing = as.numeric(lapply(healing, as.numeric))

# Did injury involve flipper/pectoral?
 pectoral = paste(c("pectoral","flipper","pecs"), collapse="|")
   pectoral = grepl(pectoral, df$Narrative, ignore.case=TRUE)
    pectoral = as.numeric(lapply(pectoral, as.numeric))

# Narrative includes reference to swimming | diving | feeding whale?
 swim.dive = paste(c("free.*swimming", "observed feeding", "actively feeding", "swimming.*free", "swimming.*diving", "diving.*swimming",
                    "swimming.*dove", "dove.*swim", "swam", "swimming normal", "feeding normal", "moving around actively",
                    "feeding on", "feeding with", "feeding and swimming", "seen feeding", "appeared to be lunge feeding",
                    "animal was diving", "skim feeding", "normal behavior", "saw the whale swimming away", "mobility did not appear to be impaired",
                    "no apparent impacts to its mobility"), collapse = "|")

 swim.dive = grepl(swim.dive, df$Narrative, ignore.case=TRUE)
 swim.dive = as.numeric(lapply(swim.dive, as.numeric))

# Was whale trailing gear?
 trailing = paste(c("trail", "towing", "dragging", "feet behind", "ft behind", "behind whale",
                 "behind.animal", "behind the whale", "towed gear"), collapse = "|")

 trailing = grepl(trailing, df$Narrative, ignore.case=TRUE)
 trailing = as.numeric(lapply(trailing, as.numeric))

# Whale has wraps of gear (absent or present?)
 wraps.absent = paste(c("no wraps"), collapse="|")
 wraps.absent = grepl(wraps.absent, df$Narrative, ignore.case=TRUE)
 wraps.absent = as.numeric(lapply(wraps.absent, as.numeric))

# evidence of a constricting entanglement implies one or more wraps of material on whale

 wraps.present = paste(c("encircling", "wrap", "wrapped", "single wrap", "body wrap", "wrapping", "rostrum wrap", "peduncle wrap",
                         "wrap had", "spiraled around", "line through mouth and over rostrum", "line around", "constricting"), collapse="|")
 wraps.present = grepl(wraps.present, df$Narrative, ignore.case=TRUE)
 wraps.present = as.numeric(lapply(wraps.present, as.numeric))

# add cases with constricting = 1 to also represent presence of wrap(s)

 wraps.present <- c(unique(wraps.present, constricting))

# Some narratives use the phrase 'no wraps', which could be interpreted in 'wraps.present' as multiple wraps,
# due to the character string 'wraps'. Identify those cases with 'no wraps' in 'Narrative and overwrite erroneous
# wraps.present values with zero.

 wraps.absent.ind <- which(wraps.absent==1)
 wraps.present[wraps.absent.ind]=0

# Begin vessel strike covariate section, append covariates to current data frame
# Assign null Vessel Speed and Size factors as default filter to index from
  VessSpd <- rep("VSpdUnk", nrow(df))
  VessSz <- rep("VSzUnk", nrow(df))

# Vessel Variables (VSize and VSpeed)
#  Archive Vessel Size and Speed strings

# identify character vector that includes all unique numeric values in data$Narrative
  all.values <- unlist(regmatches(df$Narrative, gregexpr("[0-9]*\\.?[0-9]", df$Narrative)))
  all.values <- as.character(unique(as.numeric(all.values)))
  all.values <- as.numeric(sort(all.values))

# parse by vessel size (small, large) and speed (slow, fast) #####
# omit VSm values==5 due to grep identifying '65' (vessel size threshold) as a longer case of '5'
# there are no 5 ft long vessels other than kayaks and rafts, which are typically identified as such in narratives

       VSm <- all.values[all.values<65 & all.values!=5]
       VLg <- all.values[all.values>=65]

# create character vectors of Vsize and VSpeed for use with grep, grepl, or regexpr

       VSzUnk.strings <- c("unable to determine vessel size|vessel size unknown|
                          unknown vessel size|size of vessel undetermined|vessel size
                          and speed unknown|size unk|unk size")

       VSm1 <- paste(" ", VSm, "ft", sep="", collapse="|")
       VSm2 <- paste(" ", VSm, " ft", sep="", collapse="|")
       VSm3 <- paste(VSm, "ft", sep="", collapse="|")
       VSm4 <- paste(" ", VSm, "feet", sep="", collapse="|")
       VSm5 <- paste(" ", VSm, " feet", sep="", collapse="|")
       VSm6 <- paste(VSm, "feet", sep="", collapse="|")
       VSm7 <- paste(" ", VSm, " feet", sep="", collapse="|")
       VSm8 <- paste(" ", VSm, " foot", sep="", collapse="|")
       VSm9 <- paste(" ", VSm, "foot", sep="", collapse="|")

       VSm.strings <- paste(c(VSm1, VSm2, VSm3, VSm4, VSm5, VSm6, VSm7, VSm8, VSm9), sep=",", collapse="|")
       More.VSm.strings <- c("<65","-65", "->65", "less than 65", "sailboat",
                             "recreation", "rec boat", "kayak", "pleasure", "private", "sport")

       VSm.strings <- paste(c(VSm.strings, More.VSm.strings), sep=",", collapse="|")

       VLg1 <- paste(" ", VLg, "ft", sep="", collapse="|")
       VLg2 <- paste(" ", VLg, " ft", sep="", collapse="|")
       VLg3 <- paste(VLg, "ft", sep="", collapse="|")
       VLg4 <- paste(" ", VLg, "feet", sep="", collapse="|")
       VLg5 <- paste(" ", VLg, " feet", sep="", collapse="|")
       VLg6 <- paste(VLg, "feet", sep="", collapse="|")
       VLg7 <- paste(" ", VLg, " feet", sep="", collapse="|")
       VLg8 <- paste(" ", VLg, " foot", sep="", collapse="|")
       VLg9 <- paste(" ", VLg, "foot", sep="", collapse="|")

       VLg.strings <- paste(c(VLg1, VLg2, VLg3, VLg4, VLg5, VLg6, VLg7, VLg8, VLg9), sep=",", collapse="|")

       More.VLg.strings <- c(" >65", "> 65", "container ship", "size much greater than whale",
                             "in excess of 65 ft", "cruise ship", "navy", "transport",
                             "ferry", "express", "vessel larger than whale", "assumed to be larger",
                             "much larger than the whale", "wrapped around bow", "bow of a large ship",
                             "larger and faster than whale", "wrapped around bow", "brought into",
                             "freight", "large ship")

       VLg.strings <- paste(c(VLg.strings, More.VLg.strings), sep=",", collapse="|")

# indices for known vessel size identified first as filter
       VSm.ind <- grep(VSm.strings, df$Narrative, ignore.case=TRUE)
       VLg.ind <- grep(VLg.strings, df$Narrative, ignore.case=TRUE)

# Vessel Speed descriptions / definitions VSpeed threshold is <= 10 kts and >10 kts

       VSlow <- all.values[all.values<=10]
       VFast <- all.values[all.values>10]

       VSlow1 <- paste(" ", VSlow, "kt", sep="", collapse="|")
       VSlow2 <- paste(" ", VSlow, " kt", sep="", collapse="|")
       VSlow3 <- paste(VSlow, "kt", sep="", collapse="|")
       VSlow4 <- paste(" ", VSlow, "kts", sep="", collapse="|")
       VSlow5 <- paste(" ", VSlow, " kts", sep="", collapse="|")
       VSlow6 <- paste(VSlow, "kts", sep="", collapse="|")
       VSlow7 <- paste(" ", VSlow, "knots", sep="", collapse="|")
       VSlow8 <- paste(" ", VSlow, " knots", sep="", collapse="|")
       VSlow9 <- paste(VSlow, "knots", sep="", collapse="|")

       VFast1 <- paste(" ", VFast, "kt", sep="", collapse="|")
       VFast2 <- paste(" ", VFast, " kt", sep="", collapse="|")
       VFast3 <- paste(VFast, "kt", sep="", collapse="|")
       VFast4 <- paste(" ", VFast, "kts", sep="", collapse="|")
       VFast5 <- paste(" ", VFast, " kts", sep="", collapse="|")
       VFast6 <- paste(VFast, "kts", sep="", collapse="|")
       VFast7 <- paste(" ", VFast, "knots", sep="", collapse="|")
       VFast8 <- paste(" ", VFast, " knots", sep="", collapse="|")
       VFast9 <- paste(VFast, "knots", sep="", collapse="|")

       VSpdUnk.strings <- c("speed unknown|unknown speed|no data on vessel size and speed
       |unknown vessel size and speed|vessel size and speed unknown|unknown size and speed
       |speed of vessel unknown|speed unk|unk speed")

       VSlow.strings <- paste(c(VSlow1, VSlow2, VSlow3, VSlow4, VSlow5, VSlow6, VSlow7, VSlow8, VSlow9), sep=",", collapse="|")
       More.VSlow.strings <- paste("<10kt", "<10 kt", "<=10 kt", "<10 knots", "<10 kts", "stationary", "steerage", "kayak", sep="", collapse="|")
       VSlow.strings <- paste(c(VSlow.strings, More.VSlow.strings), sep=",", collapse="|")

       VFast.strings <- paste(c(VFast1, VFast2, VFast3, VFast4, VFast5, VFast6, VFast7, VFast8, VFast9), sep=",", collapse="|")
       More.VFast.strings <- c("fast moving", "fast-moving", "high rate", "wrapped around bow", "stuck on bow", "larger and faster than whale", "bow of a large ship", ">10kt", ">10 kt", ">10 knots", ">10 kts", "exceeded 10 kts", "exceeded 10kts")
       VFast.strings <- paste(c(VFast.strings, More.VFast.strings), sep=",", collapse="|")

       VSlow.ind <- grep(VSlow.strings, df$Narrative, ignore.case=TRUE)
       VFast.ind <- grep(VFast.strings, df$Narrative, ignore.case=TRUE)

       VessSz[VSm.ind] <- "VSzSmall"
       VessSz[VLg.ind] <- "VSzLarge"

       VessSpd[VSlow.ind] <- "VSpdSlow"
       VessSpd[VFast.ind] <- "VSpdFast"

# overwrite entanglement 'CAUSE=EN' records with unknown vessel sizes / speeds

       EN.ind <- which(df$CAUSE=="EN")
       VessSz[EN.ind] <- "VSzUnk"
       VessSpd[EN.ind] <- "VSpdUnk"

# narratives in conflict for size and speed (addressed by assigning more severe speed / size
# category in 'Narrative'. Example: cases where size and speed of vessel are described as
# 'unknown', but the cruising speed or damage to whale allows inference of a large + fast
# vessel. Whale carcasses that come into port on the bow of a large container ship are assigned
# fast vessel speeds by default. Same for vessel size, if described as larger than whale, the
# vessel size is assigned as VSizeLg). To resolve these conflicts, the unknown categories are
# indexed first and narratives that contain matches between unknown and unknown categories are
# assigned the known category last (Fast supercedes Unknown and Slow, Large supercedes Unknown and Small)


       df <- cbind.data.frame(df, mobility.limited, calf.juv, constricting, decline, extensive.severe, fluke.peduncle, gear.free, head, healing,
                             laceration.deep, laceration.shallow, pectoral, swim.dive, trailing, VessSpd, VessSz, wraps.present, wraps.absent)

       df$VessSpd <- factor(df$VessSpd)
       df$VessSz <- factor(df$VessSz)

       levels(df$VessSpd) <- c(levels(df$VessSpd), "VSpdUnk", "VSpdSlow", "VSpdFast")
       levels(df$VessSz) <- c(levels(df$VessSz), "VSzUnk", "VSzLarge", "VSzSmall")

       df   }
