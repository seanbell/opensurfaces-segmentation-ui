from django.conf.urls import patterns, url
from segmentation.views import demo

urlpatterns = patterns(
    '',
    url(r'^demo/$', demo, name='demo'),
)
