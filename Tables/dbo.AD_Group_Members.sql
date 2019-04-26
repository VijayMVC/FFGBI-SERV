CREATE TABLE [dbo].[AD_Group_Members]
(
[GroupMemberKey] [int] NOT NULL IDENTITY(1, 1),
[GroupID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[UserId] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_Group_Members] ADD CONSTRAINT [PK_AD_GroupMembers] PRIMARY KEY CLUSTERED  ([GroupMemberKey]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AD_GroupMembers_USER_ID_INDEX] ON [dbo].[AD_Group_Members] ([GroupID], [UserId]) ON [PRIMARY]
GO
