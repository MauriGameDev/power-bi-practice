//Odata Feed
//https://analytics.dev.azure.com/{org}/{project}/_odata/v4.0-preview/

let
   Source = OData.Feed("https://analytics.dev.azure.com/CosmicFireStudios/CFS_Studio/_odata/v4.0-preview/", null, [Implementation="2.0"]),
   Iterations_table = Source{[Name="Iterations", Signature="table"]}[Data],
   #"Removed Columns" = Table.RemoveColumns(Iterations_table,{"ProjectSK", "IterationId", "Number", "AnalyticsUpdatedDate", "Project", "Teams", "IterationLevel11", "IterationLevel12", "IterationLevel13", "IterationLevel14", "Depth", "IterationLevel6", "IterationLevel7", "IterationLevel8", "IterationLevel9", "IterationLevel10", "IterationLevel5", "IterationLevel4"}),
   //Fix timezone dates 
   FixDates = Table.TransformColumns(
      #"Removed Columns",
      {
         {"StartDate", each if _ = null then null else DateTime.Date(DateTimeZone.RemoveZone(_)), type date},
         {"EndDate", each if _ = null then null else DateTime.Date(DateTimeZone.RemoveZone(_)), type date}
      }
   )
in
   FixDates
