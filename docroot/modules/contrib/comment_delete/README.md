# Comment Delete

Enhances the comment delete workflow and handling of replies. Introduces the hard delete, partial hard delete, and
soft delete operation handlers. Hard delete is the default Drupal core behavior, both the comment and its replies
are permanently deleted. Partial hard delete permanently deletes the original comment and moves its replies up one
thread level. Soft delete either unpublishes or unsets field values of the original comment and keeps its replies.
Each comment field instance may have its own deletion rules and configuration.

## Usage

1. Download and install the `drupal/comment_delete` module. Recommended install method is composer:
   ```
   composer require drupal/comment_delete
   ```
2. Go to the "Manage fields" tab of the entity type containing the comment field.
3. Edit the desired comment field.
4. Review available configurations under the comment delete section and save changes.
5. Set comment delete user role permissions.

## Permissions

A number of user role permissions are available both statically and dynamically. Each comment type and field
has its own permission sets. In addition to static permission sets that apply across all comment types and fields.
See the "Comment Delete" section on the user role permissions administration page.
