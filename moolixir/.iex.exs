# Aliases for parent modules in the Moolixir project
# This file is loaded automatically when you start IEx in the Moolixir project directory.
alias Analytics, as: AN
alias APIGateway, as: APIG
alias CattleManagement, as: CM
alias DataIngestion, as: DI
alias DataStorage, as: DS
alias EventProcessing, as: EP
alias FeedManagement, as: FM

# Aliases for child modules
alias DataIngestion.DataGeneration.CattleDataGenerator, as: CDGen
alias DataIngestion.DataGeneration.CattleDataUpdater, as: CDUp
alias DataIngestion.CattleDataStream, as: CDStream
alias DataIngestion.CattleDataSender, as: CDSend
alias DataIngestion.CattleDataReceiver, as: CDRecv
