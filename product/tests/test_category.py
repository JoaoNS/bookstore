import pytest
from product.models import Category


@pytest.mark.django_db
def create_create_category():
    category = Category.objects.create(
        title="test_title", slug="test_slug", description="test_description"
    )

    assert category.title == "test_title"
    assert category.slug == "test_slug"
    assert category.description == "test_description"
