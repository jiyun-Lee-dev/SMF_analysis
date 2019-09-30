#set working directory
setwd("C:/R/Project_Ex/SwinForever_Ex")

#data 불러오기
resultR <- read.csv("raw_result2.csv", stringsAsFactors = FALSE)
head(resultR)


#의미없는 data 제거
resultA <- subset(resultR, resultR$rank!='불참')
resultA <- subset(resultA, resultA$rank!='실격')
resultA <- subset(resultA, resultA$rank!='중도포기')
resultA <- subset(resultA, resultA$rank!='DQ')
resultA <- subset(resultA, resultA$remark!='실격')
resultA <- subset(resultA, resultA$remark!='불참')
resultA <- subset(resultA, resultA$remark!='실격 한손터치')
resultA <- subset(resultA, resultA$remark!='실격 부정출발')
resultA <- subset(resultA, resultA$remark!='영법실격')
resultA <- subset(resultA, resultA$remark!='비고')
resultA <- subset(resultA, resultA$remark!='기권')
resultA <- subset(resultA, resultA$remark!='DQ')
resultA <- subset(resultA, resultA$record!='')
resultA <- subset(resultA, resultA$record!='00:00.0')
resultA <- subset(resultA, resultA$record!='100000')

#data가 예상대로 구상되었는지
str(resultA)
#data 요약 통계
summary(resultA)


#data 추리기(for 예측을 위한 분류)
resultSimple <- resultA[c("pname", "psex", "style", "distance", "record", "Date")]
resultSimple <- na.omit(resultSimple)
head(resultSimple)

#기록, 날짜, 년도 numeric으로 변
resultSimple$record <-  as.numeric(resultSimple$record)
resultSimple$Date <-  as.numeric(resultSimple$Date)

#data가 예상대로 구상되었는지
str(resultSimple)
#data 요약 통계
summary(resultSimple)

#종목별 subset
breast50 <- subset(resultSimple, resultSimple$style=='평영'&resultSimple$distance=='50')
breast100 <- subset(resultSimple, resultSimple$style=='평영'&resultSimple$distance=='100')
butterfly50 <- subset(resultSimple, resultSimple$style=='접영'&resultSimple$distance=='50')
butterfly100 <- subset(resultSimple, resultSimple$style=='접영'&resultSimple$distance=='100')
free50 <- subset(resultSimple, resultSimple$style=='자유형'&resultSimple$distance=='50')

free100 <- subset(resultSimple, resultSimple$style=='자유형'&resultSimple$distance=='100')
back50 <- subset(resultSimple, resultSimple$style=='배영'&resultSimple$distance=='50')
back100 <- subset(resultSimple, resultSimple$style=='배영'&resultSimple$distance=='100')

#종목별 histogram
par(mfrow=c(2,2))
plot(density((breast50$record)))
plot(density((breast100$record)))
plot(density((butterfly50$record)))
plot(density((butterfly100$record)))
plot(density((free50$record)))
plot(density((free100$record)))
plot(density((back50$record)))
plot(density((back100$record)))

#각 종목에 대해 기록 범위 추리기
breast50 <- subset(breast50, (2000  <= breast50$record)&(breast50$record <= 15000))
breast100 <- subset(breast100, (0  <= breast100$record)&(breast100$record <= 35000))
butterfly50 <- subset(butterfly50, (2000  <= butterfly50$record)&(butterfly50$record <= 15000))
butterfly100 <- subset(butterfly100, (0  <= butterfly100$record)&(butterfly100$record <= 35000))
free50 <- subset(free50, (2000  <= free50$record)&(free50$record <= 15000))
free100 <- subset(free100, (0  <= free100$record)&(free100$record <= 30000))
back50 <- subset(back50, (2000  <= back50$record)&(back50$record <= 15000))
back100 <- subset(back100, (0  <= back100$record)&(back100$record <= 30000))

#정규분포
plot(dnorm(as.numeric(breast50$record), mean=0, sd=1))

#종목별 밀도함수
par(mfrow=c(2,2))
plot(rnorm((breast50$record)))
par(new=TRUE)
plot(density((breast100$record)))
par(new=TRUE)
plot(density((butterfly50$record)))
par(new=TRUE)
plot(density((butterfly100$record)))
par(new=TRUE)
plot(density((free50$record)))
par(new=TRUE)
plot(density((free100$record)))
par(new=TRUE)
plot(density((back50$record)))
par(new=TRUE)
plot(density((back100$record)))

#종목별 각 사람의 평균
breast50Mean <- aggregate(record~pname, breast50, mean)
breast100Mean <- aggregate(record~pname, breast100, mean)
butterfly50Mean <- aggregate(record~pname, butterfly50, mean)
butterfly100Mean <- aggregate(record~pname, butterfly100, mean)
free50Mean <- aggregate(record~pname, free50, mean)
free100Mean <- aggregate(record~pname, free100, mean)
back50Mean <- aggregate(record~pname, back50, mean)
back100Mean <- aggregate(record~pname, back100, mean)

#종목별 각 사람의 평균 밀도함수
par(mfrow=c(2,2))
plot(density((breast50Mean$record)))
plot(density((breast100Mean$record)))
plot(density((butterfly50Mean$record)))
plot(density((butterfly100Mean$record)))
plot(density((free100Mean$record)))
plot(density((free50Mean$record)))
plot(density((back50Mean$record)))
plot(density((back100Mean$record)))


#레벨 나누고 이름vector 생성 함수
divideLevel <- function(styleDisMean, level){
  tempbound <- quantile(styleDisMean$record, c(0.1, 0.25, 0.5, 0.75))#10 15 25 25 25
  if(level=='1'){
    tempv <- subset(styleDisMean, styleDisMean$record <= tempbound[[1]] )[,1]
  }
  else if(level=='2'){
    tempv <- subset(styleDisMean, (tempbound[[1]] < styleDisMean$record)&(styleDisMean$record <= tempbound[[2]]))[,1]
  }
  else if(level=='3'){
    tempv <- subset(styleDisMean, (tempbound[[2]] < styleDisMean$record)&(styleDisMean$record <= tempbound[[3]]))[,1]
  }
  else if(level=='4'){
    tempv <- subset(styleDisMean, (tempbound[[3]] < styleDisMean$record)&(styleDisMean$record <= tempbound[[4]]))[,1]
  }
  else if(level=='5'){
    tempv <- subset(styleDisMean, styleDisMean$record > tempbound[[4]])[,1]
  }
  return(tempv)
}

#종목거리별 레벨 나누기(사람별 평균기록으로) -> 이름vector생성
breast50hhName <- divideLevel(breast50Mean, 1)
breast50hName <- divideLevel(breast50Mean, 2)
breast50mhName <- divideLevel(breast50Mean, 3)
breast50mName <- divideLevel(breast50Mean, 4)
breast50lName <- divideLevel(breast50Mean, 5)

breast100hhName <- divideLevel(breast100Mean, 1)
breast100hName <- divideLevel(breast100Mean, 2)
breast100mhName <- divideLevel(breast100Mean, 3)
breast100mName <- divideLevel(breast100Mean, 4)
breast100lName <- divideLevel(breast100Mean, 5)

butterfly50hhName <- divideLevel(butterfly50Mean, 1)
butterfly50hName <- divideLevel(butterfly50Mean, 2)
butterfly50mhName <- divideLevel(butterfly50Mean, 3)
butterfly50mName <- divideLevel(butterfly50Mean, 4)
butterfly50lName <- divideLevel(butterfly50Mean, 5)

butterfly100hhName <- divideLevel(butterfly100Mean, 1)
butterfly100hName <- divideLevel(butterfly100Mean, 2)
butterfly100mhName <- divideLevel(butterfly100Mean, 3)
butterfly100mName <- divideLevel(butterfly100Mean, 4)
butterfly100lName <- divideLevel(butterfly100Mean, 5)

free50hhName <- divideLevel(free50Mean, 1)
free50hName <- divideLevel(free50Mean, 2)
free50mhName <- divideLevel(free50Mean, 3)
free50mName <- divideLevel(free50Mean, 4)
free50lName <- divideLevel(free50Mean, 5)

free100hhName <- divideLevel(free100Mean, 1)
free100hName <- divideLevel(free100Mean, 2)
free100mhName <- divideLevel(free100Mean, 3)
free100mName <- divideLevel(free100Mean, 4)
free100lName <- divideLevel(free100Mean, 5)

back50hhName <- divideLevel(back50Mean, 1)
back50hName <- divideLevel(back50Mean, 2)
back50mhName <- divideLevel(back50Mean, 3)
back50mName <- divideLevel(back50Mean, 4)
back50lName <- divideLevel(back50Mean, 5)

back100hhName <- divideLevel(back100Mean, 1)
back100hName <- divideLevel(back100Mean, 2)
back100mhName <- divideLevel(back100Mean, 3)
back100mName <- divideLevel(back100Mean, 4)
back100lName <- divideLevel(back100Mean, 5)

#종목거리별 레벨 dataframe생성 함수
styleDisLevel.df <- function(styleDis, styleDisLevelName){
  i <- 1
  tempdf <- data.frame()
  while(i <= length(styleDisLevelName)){
    tempindex <- which(styleDis$pname==styleDisLevelName[i])
    j <- 1
    while (j <= length(tempindex)) {
      tempdf <- rbind(tempdf, styleDis[tempindex[j],])
      j <- j+1
    }
    i <- i+1
  }
  return(tempdf)
}

#종목거리별 레벨 dataframe생성
breast50hh <- styleDisLevel.df(breast50, breast50hhName)
breast50h <- styleDisLevel.df(breast50, breast50hName)
breast50mh <- styleDisLevel.df(breast50, breast50mhName)
breast50m <- styleDisLevel.df(breast50, breast50mName)
breast50l <- styleDisLevel.df(breast50, breast50lName)

breast100hh <- styleDisLevel.df(breast100, breast100hhName)
breast100h <- styleDisLevel.df(breast100, breast100hName)
breast100mh <- styleDisLevel.df(breast100, breast100mhName)
breast100m <- styleDisLevel.df(breast100, breast100mName)
breast100l <- styleDisLevel.df(breast100, breast100lName)

butterfly50hh <- styleDisLevel.df(butterfly50, butterfly50hhName)
butterfly50h <- styleDisLevel.df(butterfly50, butterfly50hName)
butterfly50mh <- styleDisLevel.df(butterfly50, butterfly50mhName)
butterfly50m <- styleDisLevel.df(butterfly50, butterfly50mName)
butterfly50l <- styleDisLevel.df(butterfly50, butterfly50lName)

butterfly100hh <- styleDisLevel.df(butterfly100, butterfly100hhName)
butterfly100h <- styleDisLevel.df(butterfly100, butterfly100hName)
butterfly100mh <- styleDisLevel.df(butterfly100, butterfly100mhName)
butterfly100m <- styleDisLevel.df(butterfly100, butterfly100mName)
butterfly100l <- styleDisLevel.df(butterfly100, butterfly100lName)

free50hh <- styleDisLevel.df(free50, free50hhName)
free50h <- styleDisLevel.df(free50, free50hName)
free50mh <- styleDisLevel.df(free50, free50mhName)
free50m <- styleDisLevel.df(free50, free50mName)
free50l <- styleDisLevel.df(free50, free50lName)

free100hh <- styleDisLevel.df(free100, free100hhName)
free100h <- styleDisLevel.df(free100, free100hName)
free100mh <- styleDisLevel.df(free100, free100mhName)
free100m <- styleDisLevel.df(free100, free100mName)
free100l <- styleDisLevel.df(free100, free100lName)

back50hh <- styleDisLevel.df(back50, back50hhName)
back50h <- styleDisLevel.df(back50, back50hName)
back50mh <- styleDisLevel.df(back50, back50mhName)
back50m <- styleDisLevel.df(back50, back50mName)
back50l <- styleDisLevel.df(back50, back50lName)

back100hh <- styleDisLevel.df(back100, back100hhName)
back100h <- styleDisLevel.df(back100, back100hName)
back100mh <- styleDisLevel.df(back100, back100mhName)
back100m <- styleDisLevel.df(back100, back100mName)
back100l <- styleDisLevel.df(back100, back100lName)

#대회별로 상하위 10%버리기
drow10per <- function(styleDistanceLevel){
  #날짜vector(중복제외)
  tempDate<- c(styleDistanceLevel$Date)
  tempDate <- unique(tempDate)
  tempdf <- data.frame()
  for(i in 1:length(tempDate)){
    dfbyDate <- subset(styleDistanceLevel, styleDistanceLevel$Date==tempDate[i])
    if(length(dfbyDate)>=3){
      temper <- quantile(dfbyDate$record, c(0.1, 0.9))
      dfbyDate <- subset(dfbyDate, (temper[[1]] <= dfbyDate$record)&(dfbyDate$record <= temper[[2]]))
    }
    tempdf <- rbind(tempdf, dfbyDate)
  }
  return(tempdf)
}

#종목거리별 레벨df 에서 상하위 10%버린 df 
breast50hh.n <- drow10per(breast50hh)
breast50h.n <- drow10per(breast50h)
breast50mh.n <- drow10per(breast50mh)
breast50m.n <- drow10per(breast50m)
breast50l.n <- drow10per(breast50l)

breast100hh.n <- drow10per(breast100hh)
breast100h.n <- drow10per(breast100h)
breast100mh.n <- drow10per(breast100mh)
breast100m.n <- drow10per(breast100m)
breast100l.n <- drow10per(breast100l)

butterfly50hh.n <- drow10per(butterfly50hh)
butterfly50h.n <- drow10per(butterfly50h)
butterfly50mh.n <- drow10per(butterfly50mh)
butterfly50m.n <- drow10per(butterfly50m)
butterfly50l.n <- drow10per(butterfly50l)

butterfly100hh.n <- drow10per(butterfly100hh)
butterfly100h.n <- drow10per(butterfly100h)
butterfly100mh.n <- drow10per(butterfly100mh)
butterfly100m.n <- drow10per(butterfly100m)
butterfly100l.n <- drow10per(butterfly100l)

free50hh.n <- drow10per(free50hh)
free50h.n <- drow10per(free50h)
free50mh.n <- drow10per(free50mh)
free50m.n <- drow10per(free50m)
free50l.n <- drow10per(free50l)

free100hh.n <- drow10per(free100hh)
free100h.n <- drow10per(free100h)
free100mh.n <- drow10per(free100mh)
free100m.n <- drow10per(free100m)
free100l.n <- drow10per(free100l)

back50hh.n <- drow10per(back50hh)
back50h.n <- drow10per(back50h)
back50mh.n <- drow10per(back50mh)
back50m.n <- drow10per(back50m)
back50l.n <- drow10per(back50l)

back100hh.n <- drow10per(back100hh)
back100h.n <- drow10per(back100h)
back100mh.n <- drow10per(back100mh)
back100m.n <- drow10per(back100m)
back100l.n <- drow10per(back100l)
#------------#쓸 수있는 데이터#---------------

##원래기록을 '01'로 통일시켜주는 함수(중복도 없앰)
makeDate01 <- function(styleDisLeveln){
  LevelnMean <- aggregate(record~Date, styleDisLeveln, mean) #Date별로 기록1개씩(평균)
  LevelnMean[order(LevelnMean$Date),]
  LevelnMean$Date <- as.factor(LevelnMean$Date)
  LevelnMean$Date <- paste0(substr(LevelnMean$Date,1,6),'01')
  LevelnMean$Date <- as.numeric(LevelnMean$Date)
  LevelnMean <- aggregate(record~Date, LevelnMean, mean)
  return(LevelnMean)
}


##연속적인 값을 만들어주는 함수
fillrecord <- function(styleDisLeveln){
  LevelnMean <- aggregate(record~Date, styleDisLeveln, mean) #Date별로 기록1개씩(평균)
  LevelnMean[order(LevelnMean$Date),]
  #LevelnMean$Date <- as.factor(LevelnMean$Date)
  LevelnMean$Date <- paste0(substr(LevelnMean$Date,1,6),'01')
  LevelnMean$Date <- as.numeric(LevelnMean$Date)
  LevelnMean <- aggregate(record~Date, LevelnMean, mean)
  yearDay <- LevelnMean$Date
  newdf <- data.frame()
  for (i in 1:(length(yearDay)-1)) {
    z1 <- substr(yearDay[i+1], 1, 4)
    z2 <- substr(yearDay[i], 1, 4)
    yabst <- as.numeric(z1) - as.numeric(z2)
    {
      if(yabst ==0){
        k <- yearDay[i+1] - yearDay[i]
        if(k==100) {next}
        k <- k/100
      }
      else{
        k <- as.numeric(substr(yearDay[i+1], 5, 6)) + (yabst*12) - as.numeric(substr(yearDay[i], 5, 6))
      }
    }
    recordabst <- (LevelnMean$record[which(LevelnMean$Date==yearDay[i+1])] - LevelnMean$record[which(LevelnMean$Date==yearDay[i])])/k
    tempdf <- data.frame()
    for(j in 1:(k-1)){
      tempD <- yearDay[i]+(100*j)
      if(as.numeric(substr(tempD,5,6))>12){
        s1 <- as.numeric(substr(tempD,5,6))%/%12
        tempD <- tempD + (s1*10000) - (s1*1200)
      }
      tempdf <- rbind(tempdf, list(tempD, (LevelnMean$record[which(LevelnMean$Date==yearDay[i])]+(recordabst*j))))
    }
    names(tempdf) <- c('Date', 'record')
    newdf <- rbind(newdf, tempdf)
    names(newdf) <- c('Date', 'record')
  }
  LevelnMean <- rbind(LevelnMean, newdf)
  LevelnMean <- aggregate(record~Date, LevelnMean, mean)
  return(LevelnMean)
}

#
breast50hh.F <- fillrecord(breast50hh.n)
breast50h.F <- fillrecord(breast50h.n)
breast50mh.F <- fillrecord(breast50mh.n)
breast50m.F <- fillrecord(breast50m.n)
breast50l.F <- fillrecord(breast50l.n)

breast100hh.F <- fillrecord(breast100hh.n)
breast100h.F <- fillrecord(breast100h.n)
breast100mh.F <- fillrecord(breast100mh.n)
breast100m.F <- fillrecord(breast100m.n)
breast100l.F <- fillrecord(breast100l.n)

butterfly50hh.F <- fillrecord(butterfly50hh.n)
butterfly50h.F <- fillrecord(butterfly50h.n)
butterfly50mh.F <- fillrecord(butterfly50mh.n)
butterfly50m.F <- fillrecord(butterfly50m.n)
butterfly50l.F <- fillrecord(butterfly50l.n)

butterfly100hh.F <- fillrecord(butterfly100hh.n)
butterfly100h.F <- fillrecord(butterfly100h.n)
butterfly100mh.F <- fillrecord(butterfly100mh.n)
butterfly100m.F <- fillrecord(butterfly100m.n)
butterfly100l.F <- fillrecord(butterfly100l.n)

free50hh.F <- fillrecord(free50hh.n)
free50h.F <- fillrecord(free50h.n)
free50mh.F <- fillrecord(free50mh.n)
free50m.F <- fillrecord(free50m.n)
free50l.F <- fillrecord(free50l.n)

free100hh.F <- drow10per(free100hh.n)
free100h.F <- drow10per(free100h.n)
free100mh.F <- drow10per(free100mh.n)
free100m.F <- drow10per(free100m.n)
free100l.F <- drow10per(free100l.n)

back50hh.F <- drow10per(back50hh.n)
back50h.F <- drow10per(back50h.n)
back50mh.F <- drow10per(back50mh.n)
back50m.F <- drow10per(back50m.n)
back50l.F <- drow10per(back50l.n)

back50hh.F <- drow10per(back100hh.n)
back50h.F <- drow10per(back100h.n)
back50mh.F <- drow10per(back100mh.n)
back50m.F <- drow10per(back100m.n)
back50l.F <- drow10per(back100l.n)


free100mh.nd <- aggregate(record~Date, free100mh.n, mean)
ggtimeseriesGraph1(free100mh.nd)
subjectdf <- makeSubjectDf(free100, '임순범')
ggtimeseriesGraph2(subjectdf)

####분석을 원하는 사람의 data####

##분석 대상의 dataframe생성 함수(이름, 종목거리로)
makeSubjectDf <- function(styleDis, name){
  subjectdf <- subset(styleDis, styleDis$pname==name)
  subjectdf <- aggregate(record~Date, subjectdf, mean)
  return(subjectdf)
}


##분석 대상의 종목 내의 레벨을 알려주는 함수(개인기록평균으로 찾기)
subjectLevel <- function(styleDisMean, subjectdf){
  subjectMean <- c(mean(subjectdf$record))
  boun <- quantile(styleDisMean$record, c(0.1, 0.25, 0.5, 0.75))##10,15,25,25,25
  print(boun)
  if(subjectMean <= boun[[1]]){subLevel <- c('hh')}
  else if((boun[[1]] < subjectMean)&(subjectMean <= boun[[2]])){subLevel <- c('h')}
  else if((boun[[2]] < subjectMean)&(subjectMean <= boun[[3]])){subLevel <- c('mh')}
  else if((boun[[3]] < subjectMean)&(subjectMean <= boun[[4]])){subLevel <- c('m')}
  else if(boun[[4]] < subjectMean){subLevel <- c('l')}
  print(subLevel)
  return(subLevel)
}


#개인기록 날짜와 일치하는 기록들 해당 종목거리에서 가져오는 함수(df)
styleDfbyDate <- function(subjectdf,styleDisLevel){
  subjectFDate <- subjectdf[,c('Date')]
  levelMeanBy <- data.frame()
  for(i in 1:length(subjectFDate)){
    temp <- subset(styleDisLevel, styleDisLevel$Date==subjectFDate[[i]])
    levelMeanBy <- rbind(levelMeanBy, temp)
  }
  return(levelMeanBy) #전체값df(by 개인)
}


#오차절대값들의 합->부호결정->오차값구하는함수
errorAbsSum5 <- function(subjectdf, levelMeanBy){
  errorabsSum <- vector()
  subjectDate <- subjectdf[,c('Date')]
  minus <- 0
  plus <- 0
  k <- 1
  for(i in 1:length(subjectDate)){
    a <- subset(levelMeanBy, levelMeanBy$Date==subjectDate[i])[,c('record')]
    b <- subset(subjectdf, subjectdf$Date==subjectDate[i])[,c('record')]
    c <- as.numeric(a)-as.numeric(b)
    {
      if(c >= 0 ||is.na(c)) {plus <- plus+1}
      else {minus <- minus+1}
    }
    if(i >= (length(subjectDate)-1)){
      k <- k+1
    }
    tempEachError <- k*abs(c)
    errorabsSum <- append(errorabsSum, tempEachError)
  }
  
  #errorMean구하기
  updown <- plus-minus
  errorabsMean <- sum(errorabsSum, na.rm = TRUE)/(length(subjectDate)+3)
  errorMean <- vector()
  {
    if(updown <= 0){
      errorMean <- paste0('-', errorabsMean)
      errorMean <- as.numeric(errorMean)
    }
    else {errorMean <- errorabsMean}
  }  #절댓값error에 
  return(errorMean)
}


#기록예측(by 오차값 비교)
predicRecord5 <- function(subjectdf, levelMeanBy, errorMean){
  subjectmaxDate <- max(subjectdf$Date)
  styleLevelnMeanMaxindex <- which(levelMeanBy$Date==subjectmaxDate)
  exPreRecord <- levelMeanBy[styleLevelnMeanMaxindex+1, 'record']
  predictionRecord1 <- as.numeric(exPreRecord)+as.numeric(errorMean)
  return(predictionRecord1)
}

#개인반영 및 최종예측값
weprdicRecord5 <- function(predicrecord, subjectdf){
  k <- length(subjectdf)
  subsub <- (subjectdf$record[k] - subjectdf$record[k-1])
  predicrecord <- predicrecord + subsub
  return(predicrecord)
}




par(mfrow=c(2,2))
ggtimeseriesGraph2(subjectdf)
ggtimeseriesGraph1(back50mh.nM)
plot(subjectdf$Date, subjectdf$record, type='o', col='blue')
#####================
subjectdf <- makeSubjectDf(back50, '원혜성')  #원래개인기록(2) #일별
plot(subjectdf$record, type='o', col='blue', main='원혜성 님의 배영50m 기록', xlab=' ', ylab='record')
grid()
subjectdf <- subset(subjectdf, subjectdf$Date!=20140622)#상하10%제외
subjectdf <- subset(subjectdf, subjectdf$Date!=20170422)#상하10%제외
testdata <- subset(subjectdf, subjectdf$Date==20170903)#testdata
subjectdf <- subset(subjectdf, subjectdf$Date!=20170903)#testdata제외
sublevel <- subjectLevel(back50Mean, subjectdf)  #level구하기
plot(subjectdf$record, type='o', col='blue')
#-----------------------------------------------------------------
#subjectdf  #일별
subjectdf01 <- makeDate01(subjectdf)  #일자를 01로 통일 및 합치기(원래)(2) #월별
subjectdf.F <- fillrecord(subjectdf)  #채운개인기록df(01포함)(채운)(2) #채운월별

back50mh.nM <- aggregate(record~Date, back50mh.n, mean) #종목거리레벨 날짜별로 평균(2) #일별(연속x)
back50mh01 <- makeDate01(back50mh.n) #일자 01로 통일 및 합치기(2)<-종목거리레벨10%제외(7) #월별
#back50mh.F  #채운월별

levelMeanBy <- styleDfbyDate(subjectdf, back50mh.nM) #개인날짜로 전체기록불러오기(일별)
levelMeanBy01 <- styleDfbyDate(subjectdf01, back50mh01) #개인날짜로 전체기록불러오기(월별)



errorMean5 <- errorAbsSum5(subjectdf, levelMeanBy)
errorMean015 <- errorAbsSum5(subjectdf01, levelMeanBy01)

predicrecord5 <- predicRecord5(subjectdf, back50mh.nM, errorMean5)
predicrecord015 <- predicRecord5(subjectdf01, back50mh01, errorMean015)


predicrecord5n <- weprdicRecord5(predicrecord5, subjectdf)
predicrecord015n <- weprdicRecord5(predicrecord015, subjectdf01)


cat('[testdata] ', testdata$Date, testdata$record, '[prediction record] ',predicrecord5,predicrecord015,  predicrecord5n, predicrecord015n)
#[testdata]  20170903 3435 [prediction record]  3617.227 2779.045 3754.365
subjectdf <- rbind(subjectdf, c(Date=20170903, record=4358.782))
plot(forgraph$record, type='o', col='blue')
#========================= 



#####================
subjectdf <- makeSubjectDf(butterfly50, '구자백')  #원래개인기록(2) #일별
plot(subjectdf$record, type='o', col='blue', main='구자백 님의 접영50m 기록', xlab=' ', ylab='record')
grid()
plot(subjectdf$record)
subjectdf <- subset(subjectdf, subjectdf$Date!=20131020)#상하10%제외
testdata <- subset(subjectdf, subjectdf$Date==20170903)#testdata
subjectdf <- subset(subjectdf, subjectdf$Date!=20170903)#testdata제외
sublevel <- subjectLevel(butterfly50Mean, subjectdf)  #level구하기
plot(subjectdf$record)
#-----------------------------------------------------------------
#subjectdf  #일별
subjectdf01 <- makeDate01(subjectdf)  #일자를 01로 통일 및 합치기(원래)(2) #월별
subjectdf.F <- fillrecord(subjectdf)  #채운개인기록df(01포함)(채운)(2) #채운월별

butterfly50h.nM <- aggregate(record~Date, butterfly50h.n, mean) #종목거리레벨 날짜별로 평균(2) #일별(연속x)
butterfly50h01 <- makeDate01(butterfly50h.n) #일자 01로 통일 및 합치기(2)<-종목거리레벨10%제외(7) #월별
#butterfly50mh.F  #채운월별

levelMeanBy <- styleDfbyDate(subjectdf, butterfly50h.nM) #개인날짜로 전체기록불러오기(일별)
levelMeanBy01 <- styleDfbyDate(subjectdf01, butterfly50h01) #개인날짜로 전체기록불러오기(월별)
#levelMeanBy.F <- styleDfbyDate(subjectdf.F, free100mh.F) #개인날짜로 전체기록불러오기(채운월별)


errorMean5 <- errorAbsSum5(subjectdf, levelMeanBy)
errorMean015 <- errorAbsSum5(subjectdf01, levelMeanBy01)
#errorMean.F5 <- errorAbsSum5(subjectdf.F, levelMeanBy.F)

predicrecord5 <- predicRecord5(subjectdf, butterfly50h.nM, errorMean5)
predicrecord015 <- predicRecord5(subjectdf01, butterfly50h01, errorMean015)
#predicrecord.F5 <- predicRecord5(subjectdf.F, free100mh.F, errorMean.F5)

predicrecord5n <- weprdicRecord5(predicrecord5, subjectdf)
predicrecord015n <- weprdicRecord5(predicrecord015, subjectdf01)
#predicrecord.F5n <- weprdicRecord5(predicrecord.F5, subjectdf.F)

cat('[testdata] ', testdata$Date, testdata$record, '[prediction record] ',predicrecord5,predicrecord015,  predicrecord5n, predicrecord015n)
#[testdata]  20170903 3435 [prediction record]  3617.227 2779.045 3754.365
subjectdf <- rbind(subjectdf, c(Date=20170903, record=3326.428))

#========================= 

#####================
  subjectdf <- makeSubjectDf(free50, '이재혁')  #원래개인기록(2) #일별
  plot(subjectdf$record, type='o', col='blue', main='이재혁 님의 자유형50m 기록', xlab=' ', ylab='record')
  grid()
  subjectdf <- subset(subjectdf, subjectdf$Date!=20170520)#상하10%제외
  testdata <- subset(subjectdf, subjectdf$Date==20170520)#testdata
  subjectdf <- subset(subjectdf, subjectdf$Date!=20161211)#testdata제외
  sublevel <- subjectLevel(free50Mean, subjectdf)  #level구하기
  plot(subjectdf$record)
  #-----------------------------------------------------------------
  #subjectdf  #일별
  subjectdf01 <- makeDate01(subjectdf)  #일자를 01로 통일 및 합치기(원래)(2) #월별
  subjectdf.F <- fillrecord(subjectdf)  #채운개인기록df(01포함)(채운)(2) #채운월별
  
  free50h.nM <- aggregate(record~Date, free50h.n, mean) #종목거리레벨 날짜별로 평균(2) #일별(연속x)
  free50h01 <- makeDate01(free50h.n) #일자 01로 통일 및 합치기(2)<-종목거리레벨10%제외(7) #월별
  #butterfly50mh.F  #채운월별
  
  levelMeanBy <- styleDfbyDate(subjectdf, free50h.nM) #개인날짜로 전체기록불러오기(일별)
  levelMeanBy01 <- styleDfbyDate(subjectdf01, free50h01) #개인날짜로 전체기록불러오기(월별)
  levelMeanBy.F <- styleDfbyDate(subjectdf.F, free50h.F) #개인날짜로 전체기록불러오기(채운월별)
  

  errorMean5 <- errorAbsSum5(subjectdf, levelMeanBy)
  errorMean015 <- errorAbsSum5(subjectdf01, levelMeanBy01)
  #errorMean.F5 <- errorAbsSum5(subjectdf.F, levelMeanBy.F)
  
  predicrecord5 <- predicRecord5(subjectdf, free50h.nM, errorMean5)
  predicrecord015 <- predicRecord5(subjectdf01, free50h01, errorMean015)
  #predicrecord.F5 <- predicRecord5(subjectdf.F, free50h.F, errorMean.F5)
  
  predicrecord5n <- weprdicRecord5(predicrecord5, subjectdf)
  predicrecord015n <- weprdicRecord5(predicrecord015, subjectdf01)
  #predicrecord.F5n <- weprdicRecord5(predicrecord.F5, subjectdf.F)
  
  cat('[testdata] ', testdata$Date, testdata$record, '[prediction record] ',predicrecord5,predicrecord015,  predicrecord5n, predicrecord015n)
  
  #[testdata]  20170903 3435 [prediction record]  3617.227 2779.045 3754.365
  
  subjectdf <- rbind(subjectdf, c(Date=20170903, record=2926.428))
#========================= 
  #####================
  subjectdf <- makeSubjectDf(breast50, '이용훈')  #원래개인기록(2) #일별
  plot(subjectdf$record)
  subjectdf <- subset(subjectdf, subjectdf$Date!=20160117)#상하10%제외
  testdata <- subset(subjectdf, subjectdf$Date==20170903)#testdata
  subjectdf <- subset(subjectdf, subjectdf$Date!=20170903)#testdata제외
  sublevel <- subjectLevel(breast50Mean, subjectdf)  #level구하기
  plot(subjectdf$record)
  #-----------------------------------------------------------------
  #subjectdf  #일별
  subjectdf01 <- makeDate01(subjectdf)  #일자를 01로 통일 및 합치기(원래)(2) #월별
  subjectdf.F <- fillrecord(subjectdf)  #채운개인기록df(01포함)(채운)(2) #채운월별
  
  breast50h.nM <- aggregate(record~Date, breast50h.n, mean) #종목거리레벨 날짜별로 평균(2) #일별(연속x)
  breast50h01 <- makeDate01(breast50h.n) #일자 01로 통일 및 합치기(2)<-종목거리레벨10%제외(7) #월별
  #butterfly50mh.F  #채운월별
  
  levelMeanBy <- styleDfbyDate(subjectdf, breast50h.nM) #개인날짜로 전체기록불러오기(일별)
  levelMeanBy01 <- styleDfbyDate(subjectdf01, breast50h01) #개인날짜로 전체기록불러오기(월별)
  levelMeanBy.F <- styleDfbyDate(subjectdf.F, breast50h.F) #개인날짜로 전체기록불러오기(채운월별)
  
  errorMean5 <- errorAbsSum5(subjectdf, levelMeanBy)
  errorMean015 <- errorAbsSum5(subjectdf01, levelMeanBy01)
  errorMean.F5 <- errorAbsSum5(subjectdf.F, levelMeanBy.F)
  
  predicrecord5 <- predicRecord5(subjectdf, breast50h.nM, errorMean)
  predicrecord015 <- predicRecord5(subjectdf01, breast50h01, errorMean01)
  predicrecord.F5 <- predicRecord5(subjectdf.F, breast50h.F, errorMean.F)
  
  predicrecord5n <- weprdicRecord5(predicrecord5, subjectdf)
  predicrecord015n <- weprdicRecord5(predicrecord015, subjectdf01)
  predicrecord.F5n <- weprdicRecord5(predicrecord.F5, subjectdf.F)
  
  cat('[testdata] ', testdata$Date, testdata$record, '[prediction record] ', predicrecord5n, predicrecord015n, predicrecord.F5n)
  #[testdata]  20170903 4115 [prediction record]  3942.912 3104.731 4110.305
  
  
  #=========================  
  #####================
  subjectdf <- makeSubjectDf(breast50, '김용구')  #원래개인기록(2) #일별
  plot(subjectdf$record)
  subjectdf <- subset(subjectdf, subjectdf$Date!=20161211)#상하10%제외
  testdata <- subset(subjectdf, subjectdf$Date==20170520)#testdata
  subjectdf <- subset(subjectdf, subjectdf$Date!=20170520)#testdata제외
  sublevel <- subjectLevel(breast50Mean, subjectdf)  #level구하기
  plot(subjectdf$record)
  #-----------------------------------------------------------------
  #subjectdf  #일별
  subjectdf01 <- makeDate01(subjectdf)  #일자를 01로 통일 및 합치기(원래)(2) #월별
  subjectdf.F <- fillrecord(subjectdf)  #채운개인기록df(01포함)(채운)(2) #채운월별
  
  breast50m.nM <- aggregate(record~Date, breast50m.n, mean) #종목거리레벨 날짜별로 평균(2) #일별(연속x)
  breast50m01 <- makeDate01(breast50h.n) #일자 01로 통일 및 합치기(2)<-종목거리레벨10%제외(7) #월별
  #butterfly50mh.F  #채운월별
  
  levelMeanBy <- styleDfbyDate(subjectdf, breast50m.nM) #개인날짜로 전체기록불러오기(일별)
  levelMeanBy01 <- styleDfbyDate(subjectdf01, breast50m01) #개인날짜로 전체기록불러오기(월별)
  levelMeanBy.F <- styleDfbyDate(subjectdf.F, breast50m.F) #개인날짜로 전체기록불러오기(채운월별)
  #=========================  
  #####================
  subjectdf <- makeSubjectDf(breast100, '김용구')  #원래개인기록(2) #일별
  plot(subjectdf$record)
  subjectdf <- subset(subjectdf, subjectdf$Date!=20161211)#상하10%제외
  testdata <- subset(subjectdf, subjectdf$Date==20170520)#testdata
  subjectdf <- subset(subjectdf, subjectdf$Date!=20170520)#testdata제외
  sublevel <- subjectLevel(breast50Mean, subjectdf)  #level구하기
  plot(subjectdf$record)
  #-----------------------------------------------------------------
  #subjectdf  #일별
  subjectdf01 <- makeDate01(subjectdf)  #일자를 01로 통일 및 합치기(원래)(2) #월별
  subjectdf.F <- fillrecord(subjectdf)  #채운개인기록df(01포함)(채운)(2) #채운월별
  
  breast50m.nM <- aggregate(record~Date, breast100m.n, mean) #종목거리레벨 날짜별로 평균(2) #일별(연속x)
  breast50m01 <- makeDate01(breast50h.n) #일자 01로 통일 및 합치기(2)<-종목거리레벨10%제외(7) #월별
  #butterfly50mh.F  #채운월별
  
  levelMeanBy <- styleDfbyDate(subjectdf, breast50m.nM) #개인날짜로 전체기록불러오기(일별)
  levelMeanBy01 <- styleDfbyDate(subjectdf01, breast50m01) #개인날짜로 전체기록불러오기(월별)
  levelMeanBy.F <- styleDfbyDate(subjectdf.F, breast50m.F) #개인날짜로 전체기록불러오기(채운월별)
  #=========================
  errorMean5 <- errorAbsSum5(subjectdf, levelMeanBy)
  errorMean015 <- errorAbsSum5(subjectdf01, levelMeanBy01)
  errorMean.F5 <- errorAbsSum5(subjectdf.F, levelMeanBy.F)
  
  predicrecord5 <- predicRecord5(subjectdf, breast50h.nM, errorMean)
  predicrecord015 <- predicRecord5(subjectdf01, breast50m01, errorMean01)
  predicrecord.F5 <- predicRecord5(subjectdf.F, breast50m.F, errorMean.F)
  
  predicrecord5n <- weprdicRecord5(predicrecord5, subjectdf)
  predicrecord015n <- weprdicRecord5(predicrecord015, subjectdf01)
  predicrecord.F5n <- weprdicRecord5(predicrecord.F5, subjectdf.F)
  
  cat('[testdata] ', testdata$Date, testdata$record, '[prediction record] ', predicrecord5n, predicrecord015n, predicrecord.F5n)
  
  

 # 
  library(xts)
  library(ggplot2)
  ggtimeseriesGraph1 <- function(styleDistanceLevel){
    styleDistanceLevel$Date <- as.factor(styleDistanceLevel$Date)
    styleDistanceLevel.td <- as.Date(styleDistanceLevel$Date, format="%Y%m%d")
    dates <- styleDistanceLevel.td
    record <- styleDistanceLevel$record
    styleDistanceLevel.xts <- data.frame(dates, record)
    styleDistanceLevel.xts <- xts(styleDistanceLevel.xts[,-1], order.by = styleDistanceLevel.td)
    ggplot(styleDistanceLevel.xts, aes(x=dates, y=record)) + geom_line(color='blue') + scale_x_date(limits=c(as.Date("2013-01-01"),as.Date("2018-12-31")))+scale_y_date(limits=c(10750,12750))+stat_smooth()
  }
  ggtimeseriesGraph2 <- function(styleDistanceLevel){
    styleDistanceLevel$Date <- as.factor(styleDistanceLevel$Date)
    styleDistanceLevel.td <- as.Date(styleDistanceLevel$Date, format="%Y%m%d")
    dates <- styleDistanceLevel.td
    record <- styleDistanceLevel$record
    styleDistanceLevel.xts <- data.frame(dates, record)
    styleDistanceLevel.xts <- xts(styleDistanceLevel.xts[,-1], order.by = styleDistanceLevel.td)
    ggplot(styleDistanceLevel.xts, aes(x=dates, y=record)) + geom_line(color='red') + scale_x_date(limits=c(as.Date("2013-01-01"),as.Date("2018-12-31")))+scale_y_date(limits=c(10750,12750))+stat_smooth(color='red')
  }
