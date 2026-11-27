## Permissions
For authorization models we use a permissions model. Every model has 4 types of permissions, create, read, update and destroy. For most models this is intuitive, but for some a permission will give more rights than expected. Those models are described below.

### User
#### Without permissions
Without permissions it is still possible to retrieve all users. Then the response will only return a limited set of attributes.

#### Read
When an user has the read permission the user will get a specified set of attributes for all users. This permission also grants for exporting user data.

#### Update
When the user has the update permission it will get all attributes. It also allows the user to update all other users. When a user doens't have the update permission it can still update their own profile.

#### Destroy
Destroying users is not possible. It is possible to archive users, to do this the destroy permission is needed.

### Group
#### Read
When the user has the read permission it is able to get all groups (as always). When it doesn't have the read permission the user can still get groups, but only those without the hidden property set to true.

### Activity/Article/Photo
#### Unauthenticated and without permission
When not logged in or when without permission it is possible to get activities and articles which have the publicly visible property set to true, and photo albums which have the visibility property set to public. Of a public photo album only the overview of its photos (`/photo_albums/:id/photos`) is available; single photos, the photos index and photo comments require logging in.

### Photo album visibility
A photo album has a visibility of `public`, `alumni` or `members`. Photos and photo comments follow the visibility of their album. A user with the read permission can see:
- all albums, when the user has the update permission on photo albums or is a current member of the 'Leden' group
- `public` and `alumni` albums, and `members` albums dated from 18 months before the start until 6 months after the end of their 'Leden' membership, when the user is a former member (albums without a date use their creation date)
- only `public` albums, when the user has never been a member of the 'Leden' group
