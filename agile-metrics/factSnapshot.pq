let
   BaseUrl = "https://analytics.dev.azure.com/",

   Source = Json.Document(
      Web.Contents(
         BaseUrl,
         [
            RelativePath = "CosmicFireStudios/CFS_Studio/_odata/v4.0-preview/WorkItemSnapshot",
            Query = [
               #"apply" = "filter(DateSk ge 20260801 and WorkItemType in ('User Story', 'Task'))/groupby ((DateSK, IterationSK, WorkItemType, StateCategory)
               aggregate($count as ItemCount, RemainingWork with sum as RemainingWork, StoryPoints with sum as StoryPoints))"
            ]
         ]
      )
   ),

   Snapshot = Table.FromRecords(
      Source[value],
      {"DateSK", "IterationSK", "WorkItemType", "StateCategory", "Count", "RemainingWork", "StoryPoints"},
      MissingField.UseNull
   ),

   RenameCount = Table.RenameColumns(Snapshot, {{"Count", "ItemCount"}}),

   SetTypes = Table.TransformColumnTypes(
      RenameCount,
      {{"DateSK", Int64.Type}, {"ItemCount", Int64.Type}, {"RemainingWork", type number}, {"StoryPoints", type number}}
   )
in
   SetTypes