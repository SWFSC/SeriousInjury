#' @title WhaleInjuryCovariates()
#'
#' @description
#' Identify Covariates for Whale Injury Assessments from
#' Narratives + Append Covariates to existing data.frame.
#'
#' Search wide-form data.frame column named 'Narrative' for words/phrases
#' to be coded as binary absence / presence (0/1) injury covariates.
#' Append to new data.frame with function WhaleInjuryCovariates().
#'
#' Resulting data.frame is used with randomForest models to predict
#' health status of whales involved in entanglements or vessel strikes.
#'
#' Package includes example data.frame 'whales'
#' (n=20 records) for use with WhaleInjuryCovariates
#'
#' @usage
#' WhaleInjuryCovariates(x)
#'
#' @param x an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples WhaleInjuryCovariates(whales)
#'
#' @export

   WhaleInjuryCovariates = function(x) {

# 02-16-2022
# Covariates defined below, starting with covariate = 'anchored'
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

# Evidence the whale was anchored or had limited mobility resulting from an entanglement?
 anchored = paste(c("anchor", "difficultly spending time at surface", "hog", "motionless",
                    "mobility","unable to move","stationary whale", "entrap",
                    "whale was stationary", "animal was stationary", "stationary animal",
                    "weighted","using flippers only", "could not freely swim"), collapse="|")

 anchored = grepl(anchored, x$Narrative, ignore.case=TRUE)

 anchored = as.numeric(lapply(anchored, as.numeric))

# Was a calf, juvenile or lactating mother involved in the case?
 calf.juv = paste(c("calf","juvenile","young","dependent"), collapse="|")
    calf.juv = grepl(calf.juv, x$Narrative, ignore.case=TRUE)
     calf.juv = as.numeric(lapply(calf.juv, as.numeric))

# Evidence of constricting entanglement?
 constricting = paste(c("constricting", "deep cut", "tight", "cutting", "impress", "embed", "pinn",
                        "twisted", "necrotic", "amputat", "missing.*fluke", "fluke.*missing", "severed"), collapse="|")

 constricting = grepl(constricting, x$Narrative, ignore.case=TRUE)
 constricting = as.numeric(lapply(constricting, as.numeric))

# Evidence of a health decline?
 decline = paste(c(" abnormal","chronic","deteriorat","fair cond","fair body","body condition fair","compromise",
                   "scoliosis","deform","cyamid","lice","lethargic","lesion","discolor","diatom","parasite","poor cond",
                   "poor health", "poor body", "poor over","poor skin","rake","discolored skin","skin discolor",
                   "slough", "thin ", "emaciat", "malnourish", "underweight", "starv"), collapse="|")

 decline = grepl(decline, x$Narrative, ignore.case=TRUE)
 decline = as.numeric(lapply(decline, as.numeric))

# 'Extensive or Severe' case resulting from entanglement or vessel strike?
 extensive.severe = paste(c("extensive","severe","severed","substantial","massive","amputat","major","missing fluke"), collapse="|")
     extensive.severe = grepl(extensive.severe, x$Narrative, ignore.case=TRUE)
      extensive.severe = as.numeric(lapply(extensive.severe, as.numeric))

# Did injury involve fluke or peduncle area?
 fluke.peduncle = paste(c("fluke","peduncle","tail"), collapse="TRUE")
      fluke.peduncle = grepl(fluke.peduncle, x$Narrative, ignore.case=TRUE)
       fluke.peduncle = as.numeric(lapply(fluke.peduncle, as.numeric))

#  Evidence that whale is now gear-free after initial sighting? Or is expected to shed loose gear?
 gear.free = paste(c("gear free", "shed", "gear-free", "no gear present", "complete removal of gear",
                      "free of gear", "self.*release", "disentangled", "removal of all gear",
                       "no gear remaining", "all gear removed"), collapse="|")

 gear.free = grepl(gear.free, x$Narrative, ignore.case=TRUE)
  gear.free = as.numeric(lapply(gear.free, as.numeric))

# Injury involved head, rostrum, or mouth?
 head = paste(c("head","baleen","mouth","rostrum","lips"," lip ", "jaw","blowhole","nares"), collapse="|")
      head = grepl(head, x$Narrative, ignore.case=TRUE)
       head = as.numeric(lapply(head, as.numeric))

# Deep laceration?
 laceration.deep = paste(c("deep.*laceration", "laceration.*deep", "muscle", "laceration.*blubber",
                              "blubber.*laceration", "laceration.*artery", "artery.*laceration",
                              "laceration.*arteri", "arteri.*laceration", "laceration.*massive",
                              "massive.*laceration", "laceration.*penetrat", "penetrat.*laceration",
                              "laceration.*necrotic", "necrotic.*laceration", "large.*laceration",
                              "laceration.*large", "laceration.*propell", "propell.*laceration",
                              "deep.*propel", "propel.*deep"), collapse="|")

 laceration.deep = grepl(laceration.deep, x$Narrative, ignore.case=TRUE)
 laceration.deep = as.numeric(lapply(laceration.deep, as.numeric))

# Shallow laceration?
 laceration.shallow = paste(c("shallow.*laceration","laceration.*shallow","minor.*laceration",
                       "laceration.*minor", "superficial.*laceration", "laceration.*superficial", "heal.*laceration",
                       "laceration.*heal", "small.*laceration","laceration.*small"), collapse="|")

 laceration.shallow = grepl(laceration.shallow, x$Narrative, ignore.case=TRUE)
 laceration.shallow = as.numeric(lapply(laceration.shallow, as.numeric))

# Deep vs Shallow laceration is hierarchical. A whale with both gets coded for a deep laceration.
# A whale with a healing laceration may have initially had a deep laceration. It is coded as deep.
# index cases with deep lacerations and recode previously-indexed shallow lacerations as zeroes

 deep.lac.pos = which(laceration.deep==1)
 laceration.shallow[deep.lac.pos] = 0

# Evidence whale is | was healing | recovering?
 healing = paste(c("healing","healed","healthy.*resight","resight.*healthy","good health",
                    "no visible injur","no injur", "no noticeable injuries", " normal behavior"), collapse="|")

 healing = grepl(healing, x$Narrative, ignore.case=TRUE)
 healing = as.numeric(lapply(healing, as.numeric))

# Did injury involve flipper/pectoral?
 pectoral = paste(c("pectoral","flipper","pecs"), collapse="|")
   pectoral = grepl(pectoral, x$Narrative, ignore.case=TRUE)
    pectoral = as.numeric(lapply(pectoral, as.numeric))

# Narrative includes reference to swimming and / or diving whale?
 swim.dive = paste(c("free.*swimming", "swimming.*free", "swimming.*diving", "diving.*swimming",
                    "swimming.*dove", "dove.*swim", "swam"), collapse = "|")

 swim.dive = grepl(swim.dive, x$Narrative, ignore.case=TRUE)
 swim.dive = as.numeric(lapply(swim.dive, as.numeric))

# Was whale trailing gear?
 trailing = paste(c("trail", "towing", "dragging", "feet behind", "ft behind", "behind whale",
                 "behind.animal", "behind the whale", "towed gear"), collapse = "|")

 trailing = grepl(trailing, x$Narrative, ignore.case=TRUE)
 trailing = as.numeric(lapply(trailing, as.numeric))

# Whale has wraps of gear (none or multiple?)
 wraps.no = paste(c("no wrap"), collapse="|")
 wraps.no = grepl(wraps.no, x$Narrative, ignore.case=TRUE)
 wraps.no = as.numeric(lapply(wraps.no, as.numeric))

 wraps.multi = paste(c("multiple wraps","several wraps","wrapped several","wrapped multiple"), collapse="|")
 wraps.multi = grepl(wraps.multi, x$Narrative, ignore.case=TRUE)
 wraps.multi = as.numeric(lapply(wraps.multi, as.numeric))

# Begin vessel strike covariate section, append covariates to current data frame
# Assign null Vessel Speed and Size factors as default filter to index from
  VessSpd <- rep("VSpdUnk", nrow(x))
  VessSz <- rep("VSzUnk", nrow(x))

# Vessel Variables (VSize and VSpeed)
#  Archive Vessel Size and Speed strings

# identify character vector that includes all unique numeric values in data$Narrative
  all.values <- unlist(regmatches(x$Narrative, gregexpr("[0-9]*\\.?[0-9]", x$Narrative)))
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
       VSm3 <- paste(" ", VSm, " feet", sep="", collapse="|")
       VSm4 <- paste(" ", VSm, " foot", sep="", collapse="|")
       VSm5 <- paste(" ", VSm, "'", sep="", collapse="|")

       VSm.strings <- paste(c(VSm1, VSm2, VSm3, VSm4, VSm5), sep=",", collapse="|")
       More.VSm.strings <- c("<65","-65", "->65", "less than 65", "sailboat",
                             "recreation", "rec boat", "kayak", "pleasure", "private", "sport")

       VSm.strings <- paste(c(VSm.strings, More.VSm.strings), sep=",", collapse="|")

       VLg1 <- paste(" ", VLg, "ft", sep="", collapse="|")
       VLg2 <- paste(" ", VLg, " ft", sep="", collapse="|")
       VLg3 <- paste(" ", VLg, " feet", sep="", collapse="|")
       VLg4 <- paste(" ", VLg, " foot", sep="", collapse="|")
       VLg5 <- paste(" ", VLg, "'", sep="", collapse="|")

       VLg.strings <- paste(c(VLg1, VLg2, VLg3, VLg4, VLg5), sep=",", collapse="|")

       More.VLg.strings <- c(" >65", "> 65", "container ship", "size much greater than whale",
                             "in excess of 65 ft", "cruise ship", "navy", "transport",
                             "ferry", "express", "vessel larger than whale", "assumed to be larger",
                             "much larger than the whale", "wrapped around bow", "bow of a large ship",
                             "larger and faster than whale", "wrapped around bow", "brought into",
                             "freight", "large ship")

       VLg.strings <- paste(c(VLg.strings, More.VLg.strings), sep=",", collapse="|")

# indices for known vessel size identified first as filter
       VSm.ind <- grep(VSm.strings, x$Narrative, ignore.case=TRUE)
       VLg.ind <- grep(VLg.strings, x$Narrative, ignore.case=TRUE)

# Vessel Speed descriptions / definitions VSpeed threshold is <= 10 kts and >10 kts

       VSlow <- all.values[all.values<=10]
       VFast <- all.values[all.values>10]

       VSlow1 <- paste(" ", VSlow, "kt", sep="", collapse="|")
       VSlow2 <- paste(" ", VSlow, " kt", sep="", collapse="|")
       VSlow3 <- paste(" ", VSlow, "knots", sep="", collapse="|")
       VSlow4 <- paste(" ", VSlow, " knots", sep="", collapse="|")

       VFast1 <- paste(" ", VFast, "kt", sep="", collapse="|")
       VFast2 <- paste(" ", VFast, " kt", sep="", collapse="|")
       VFast3 <- paste(" ", VFast, "knots", sep="", collapse="|")
       VFast4 <- paste(" ", VFast, " knots", sep="", collapse="|")
       VFast5 <- paste(VFast, " knots", sep="", collapse="|")

       VSpdUnk.strings <- c("speed unknown|unknown speed|no data on vessel size and speed
       |unknown vessel size and speed|vessel size and speed unknown|unknown size and speed
       |speed of vessel unknown|speed unk|unk speed")

       VSlow.strings <- paste(c(VSlow1, VSlow2, VSlow3, VSlow4), sep=",", collapse="|")
       More.VSlow.strings <- paste("<10kt", "<10 kt", "<=10 kt", "<10 knots", "stationary", "steerage", sep="", collapse="|")
       VSlow.strings <- paste(c(VSlow.strings, More.VSlow.strings), sep=",", collapse="|")

       VFast.strings <- paste(c(VFast1, VFast2, VFast3, VFast4, VFast5), sep=",", collapse="|")
       More.VFast.strings <- c("wrapped around bow", "stuck on bow", "larger and faster than whale", "bow of a large ship", ">10kt", ">10 kt", ">10 knots")
       VFast.strings <- paste(c(VFast.strings, More.VFast.strings), sep=",", collapse="|")

       VSlow.ind <- grep(VSlow.strings, x$Narrative, ignore.case=TRUE)
       VFast.ind <- grep(VFast.strings, x$Narrative, ignore.case=TRUE)

       VessSz[VSm.ind] <- "VSzSmall"
       VessSz[VLg.ind] <- "VSzLarge"

       VessSpd[VSlow.ind] <- "VSpdSlow"
       VessSpd[VFast.ind] <- "VSpdFast"

# overwrite entanglement 'CAUSE=EN' records with unknown vessel sizes / speeds

       EN.ind <- which(x$CAUSE=="EN")
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


       df <- cbind.data.frame(x, anchored, calf.juv, constricting, decline, extensive.severe, fluke.peduncle, gear.free, head, healing,
                             laceration.deep, laceration.shallow, pectoral, swim.dive, trailing, VessSpd, VessSz, wraps.multi, wraps.no)

       df$VessSpd <- factor(df$VessSpd)
       df$VessSz <- factor(df$VessSz)

       levels(df$VessSpd) <- c(levels(df$VessSpd), "VSpdUnk", "VSpdSlow", "VSpdFast")
       levels(df$VessSz) <- c(levels(df$VessSz), "VSzUnk", "VSzLarge", "VSzSmall")

       df   }
