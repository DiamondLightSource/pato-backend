from smtplib import SMTP
from string import Template

from fastapi import APIRouter
from pydantic import BaseModel

from ..utils.config import Config

router = APIRouter(
    tags=["Feedback"],
    prefix="/feedback",
)

email_template = Template(
    (
        "PATo feedback:\n"
        "Full Name: $full_name\n"
        "User Agent: $user_agent\n"
        "Comments: $comments"
    )
)


class FeedbackForm(BaseModel):
    fullName: str
    email: str
    comments: str
    userAgent: str


@router.post("")
def post_feedback(form_data: FeedbackForm):
    """Post user feedback to configured email address"""
    with SMTP(Config.facility.smtp_server, Config.facility.smtp_port) as smtp:
        msg = email_template.safe_substitute(
            full_name=form_data.fullName,
            user_agent=form_data.userAgent,
            comments=form_data.comments,
        )

        smtp.sendmail(form_data.email, Config.facility.contact_email, msg)

    return "OK"
