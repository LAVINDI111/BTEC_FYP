"""Initial migration

Revision ID: ee59ba2cdab8
Revises: 0ab0944286ca
Create Date: 2025-07-16 16:21:34.381780

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = 'ee59ba2cdab8'
down_revision = '0ab0944286ca'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('specializePath',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('pathCode', sa.String(length=20), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('pathCode')
    )
    with op.batch_alter_table('specializepath', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('pathCode'))

    op.drop_table('specializepath')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('specializepath',
    sa.Column('id', mysql.INTEGER(display_width=11), autoincrement=True, nullable=False),
    sa.Column('pathCode', mysql.VARCHAR(length=20), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    mysql_collate='latin1_swedish_ci',
    mysql_default_charset='latin1',
    mysql_engine='InnoDB'
    )
    with op.batch_alter_table('specializepath', schema=None) as batch_op:
        batch_op.create_index(batch_op.f('pathCode'), ['pathCode'], unique=True)

    op.drop_table('specializePath')
    # ### end Alembic commands ###
