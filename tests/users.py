from ebic.auth.template import GenericAuthUser

admin = GenericAuthUser(
    id=00, family_name="Admin", title="Dr.", given_name="McAdmin", permissions=[11]
)

em_admin = GenericAuthUser(
    id=18660, family_name="EM", title="Dr.", given_name="Admin", permissions=[8]
)

user = GenericAuthUser(
    id=18600, family_name="Generic", title="Dr.", given_name="User", permissions=[]
)
