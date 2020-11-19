# croisementsInference.r
# written by JuG
# August 05 2019


#' Do something
#' @author JuG
#' @description
#' @param
#' @details
#' @examples
#'
#'
#' @return
#' @export



croisementsInference<-function(){
  if(!require(shiny)){install.packages('shiny')}
  require(shiny)
  a <- fluidPage(

    navbarPage(id="Panel 2.x",title = NULL,

               tabPanel("Croisement 2 a 2",

                        fluidPage( tags$head(tags$style(HTML("\n.pure-table {\n    /* Remove spacing between table cells (from Normalize.css) */\n    border-collapse: collapse;\n    border-spacing: 0;\n    empty-cells: show;\n    border: 1px solid #cbcbcb;\n\ttext-align: center;\n}\n\n.pure-table caption {\n    color: #000;\n    font: italic 85%/1 arial, sans-serif;\n    padding: 1em 0;\n    text-align: center;\n}\n\n.pure-table td,\n.pure-table th {\n    border-left: 1px solid #cbcbcb;/*  inner column border */\n    border-bottom: 1px solid #cbcbcb;\n\n    font-size: inherit;\n    margin: 0;\n    overflow: visible; /*to make ths where the title is really long work*/\n    padding: 0.5em 1em; /* cell padding */\n\ttext-align: center;\n}\n\n.pure-table tr:hover {background-color: #f5f5f5}\n\n/* Consider removing this next declaration block, as it causes problems when\nthere's a rowspan on the first cell. Case added to the tests. issue#432 */\n.pure-table td:first-child,\n.pure-table th:first-child {\n    border-left-width: 0;\n}\n\n.pure-table thead {\n    background-color: #e0e0e0;\n    color: #000;\n    text-align: left;\n    vertical-align: bottom;\n}\n\n/*\nstriping:\n   even - #fff (white)\n   odd  - #f2f2f2 (light gray)\n*/\n.pure-table td {\n    background-color: transparent;\n}\n\n"))),
                                   titlePanel("Analyses descriptives croisées"),
                                   sidebarLayout(
                                     sidebarPanel(

                                       uiOutput("propositionsCROISE1"),
                                       radioButtons('qualiquantiCROISE1',
                                                    "Nature de la variable",
                                                    c(Quantitative='quant', Qualitative='qual'),
                                                    'quant'),
                                       uiOutput("propositionsCROISE2"),
                                       radioButtons('qualiquantiCROISE2',
                                                    "Nature de la variable",
                                                    c(Quantitative='quant', Qualitative='qual'),
                                                    'quant'),
                                       conditionalPanel(
                                         condition = "input.qualiquantiCROISE1 == 'qual' && input.qualiquantiCROISE2 == 'qual'",
                                         radioButtons('NATableau',
                                                      "Afficher les données manquante",
                                                      c(Non="no", Oui='always'),
                                                      "no"))



                                     ),
                                     mainPanel(
                                       fluidRow(
                                         splitLayout(cellWidths = c("30%","70%"),
                                                     downloadButton('PDFcroisements',label="AIDE et Détails",class = "butt"),
                                                     h4("Faites attention s'il y a un filtre")
                                         )
                                       ),#finFluidRow

                                       tags$head(tags$style(".butt{background-color:#E9967A;} .butt{color: black;}")),
                                       h3("Représentation graphique du lien entre les deux variables"),
                                       plotOutput('plotCROISE' ),
                                       # debut conditionnal panel QualiQuali
                                       conditionalPanel(
                                         condition = "input.qualiquantiCROISE1 == 'qual' && input.qualiquantiCROISE2 == 'qual'",
                                         h3("Tableau croisé",align = "left",style = "color:#08088A"),
                                         tableOutput("montableauCroisAUTO"),br(),
                                         tableOutput("montableauCroise2AUTO"),
                                         tableOutput("montableauCroise3AUTO"),
                                         h3("Tests d'association / Comparaison des proportions",align = "left",style = "color:#08088A"),
                                         fluidRow(
                                           splitLayout(cellWidths = c("50%","50%"),
                                                       tableOutput('AUTOtableCHI2'),
                                                       tableOutput('AUTOtableFISHER')
                                           )
                                         ),
                                         textOutput('AUTOCHI2conditions'),
                                         h3("Rapport de cotes",align = "left",style = "color:#08088A"),
                                         tableOutput('oddratioAUTO')
                                       ),# fin panelQualiQuali,
                                       # debut conditionnal panel QuantiQuali
                                       conditionalPanel(
                                         condition = "input.qualiquantiCROISE1 != input.qualiquantiCROISE2",
                                         h3("Descriptif complet",align = "left",style = "color:#08088A"),
                                         tableOutput('descr3DESCRIPTIF'),
                                         h3("Tests de comparaisons:",align = "left",style = "color:#08088A"),
                                         verbatimTextOutput ("descr3TestNormalite"),
                                         verbatimTextOutput ("descr3Testpv"),
                                         verbatimTextOutput ("descr3TestsNPv"),
                                         verbatimTextOutput ("descr3Tests_de_Student"),
                                         verbatimTextOutput("descr3TestsMANN"),
                                         verbatimTextOutput ("ChoixSortieCROISE")
                                       ), # fin Panel Quali Quanti
                                       # debut conditionnal panel QuantiQuanti
                                       conditionalPanel(
                                         condition = "input.qualiquantiCROISE1 == 'quant' && input.qualiquantiCROISE2 == 'quant'",
                                         h3("Corrélation entre deux variables quantitatives",align = "left",style = "color:#08088A"),
                                         verbatimTextOutput ("CorrelationCROISE")
                                       ),# fin panelQuantiQuali,
                                       plotOutput('plotCROISE2')
                                     )# fin MainPanel

                                   )# fin sidebarlayout
                        ))# fin fluidpage
               ,

               tabPanel("Tableau croisement",



                        fluidPage(
                          titlePanel("Analyses descriptives croisées"),
                          sidebarLayout(
                            sidebarPanel(
                              #
                              uiOutput("propositionsTableauCROISE"),
                              uiOutput("selectionVariablesCroisees1"),
                              uiOutput("selectionVariablesCroisees3"),
                              uiOutput("selectionVariablesCroisees2"),
                              radioButtons("tableauCroiseSimpli","Tableau avec abréviation :"
                                           , c( Oui = 1, Non = 0),0),
                              sliderInput("nbDec", "Nombre de decimales : ", min =0,
                                          max = 5, value= 3, step = 1),
                              downloadButton('downloadData', 'Télécharger la table')


                            ),
                            mainPanel(
                              #   fluidRow(
                              #
                              #                 downloadButton('PDFcroisements',label="AIDE et Détails",class = "butt")
                              #
                              #
                              # ),#finFluidRow

                              # tags$head(tags$style(".butt{background-color:#E9967A;} .butt{color: black;}")),
                              h3("Tableau de comparaison de populations"),
                              conditionalPanel(condition = "!is.null(input$VariableCroisees)", tableOutput('tableauCroisement'))

                            )# fin MainPanel

                          )# fin sidebarlayout
                        )# fin fluidpage
               ) # fin tabPanel tableau Croisement
    ) # fin tabset
  )

  return(a)
}

