"""spaces
Revision ID: d16c228f7177
Revises: 0b355bff351a
Create Date: 2024-07-02 11:11:57.779807
"""

import sqlalchemy as sa

from alembic import op

# revision identifiers, used by Alembic
revision = "d16c228f7177"
down_revision = "0b355bff351a"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table(
        "spaces",
        sa.Column("name", sa.String(), nullable=False),
        sa.Column("description", sa.String(), nullable=True),
        sa.Column("embedding_model_id", sa.UUID(), nullable=False),
        sa.Column("user_id", sa.UUID(), nullable=False),
        sa.Column(
            "id", sa.UUID(), server_default=sa.text("gen_random_uuid()"), nullable=False
        ),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.TIMESTAMP(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["embedding_model_id"], ["embedding_models.id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.uuid"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "spaces_completion_models",
        sa.Column("space_id", sa.UUID(), nullable=False),
        sa.Column("completion_model_id", sa.UUID(), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.TIMESTAMP(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ["completion_model_id"], ["completion_models.id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(["space_id"], ["spaces.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("space_id", "completion_model_id"),
    )
    op.create_table(
        "spaces_users",
        sa.Column("space_id", sa.UUID(), nullable=False),
        sa.Column("user_id", sa.UUID(), nullable=False),
        sa.Column("role", sa.String(), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.TIMESTAMP(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["space_id"], ["spaces.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_id"], ["users.uuid"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("space_id", "user_id"),
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table("spaces_users")
    op.drop_table("spaces_completion_models")
    op.drop_table("spaces")
    # ### end Alembic commands ###
