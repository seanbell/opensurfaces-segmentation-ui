import json

from ua_parser import user_agent_parser

from django.shortcuts import render
from django.views.decorators.csrf import ensure_csrf_cookie
from django.http import Http404, HttpResponse

@ensure_csrf_cookie
def demo(request):
    """
    Serve up a segmentation task.

    This is a demo, so we are going to hard-code an image to tag.
    In a live system, you would read the HIT id:
        hit_id = request.REQUEST['hitId']
        assignment_id = request.REQUEST['assignmentId']
    and fetch a photo from the database.

    When a user submits, the data will be in request.POST.
    request.POST will contain these extra fields corresponding
    to data sent by the task window:
        results: a dictionary mapping from the photo ID (which is just "1" in
            this example) to a list of polygons.  Example:
            {"1": [[x1,y1,x2,y2,x3,y3,...], [x1,y1,x2,y2,...]]}.
        time_ms: amount of time the user spent (whether or not
            they were active)
        time_active_ms: amount of time that the user was
            active in the current window
        action_log: a JSON-encoded log of user actions
        screen_width: user screen width
        screen_height: user screen height
        version: always "1.0"

    """
    # replace this with a fetch from your database
    if request.method == 'POST':
        # all of the user submitted data is in request.POST.
        # this prints it out so you can see all its fields:
        return json_error_response(
            "This is a demo.  Here is the data you submitted:" +
            json.dumps(request.POST))
    else:
        response = browser_check(request)
        if response:
            return response

        # hard-coded example image:
        context = {
            'min_vertices': 4,
            'min_shapes': 6,
            'content': {
                'id': 1,
                'url': 'http://farm9.staticflickr.com/8204/8177262167_d749ec58d9_h.jpg'
            },
            'ask_for_feedback': True,
            'feedback_bonus': 0.05,
            'instructions': 'mturk/mt_segment_material_inst_content.html'
        }

    return render(request, 'mturk/mt_segment_material.html', context)


def browser_check(request):
    """ Only allow firefox and chrome, and no mobile """
    valid_browser = False
    if 'HTTP_USER_AGENT' in request.META:
        ua = user_agent_parser.Parse(request.META['HTTP_USER_AGENT'])
        if ua['user_agent']['family'].lower() in ('firefox', 'chrome'):
            device = ua['device']
            if 'is_mobile' not in device or not device['is_mobile']:
                valid_browser = True
    if not valid_browser:
        return html_error_response(
            request, '''
            This task requires Google Chrome. <br/><br/>
            <a class="btn" href="http://www.google.com/chrome/"
            target="_blank">Get Google Chrome</a>
        ''')
    return None


def json_error_response(error):
    """ Return an error as a JSON object """
    return HttpResponse(
        json.dumps({'result': 'error', 'message': error}),
        mimetype='application/json')

