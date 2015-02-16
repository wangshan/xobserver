#ifndef XOBSERVER_INTERFACE_TYPE_H_INCLUDED
#define XOBSERVER_INTERFACE_TYPE_H_INCLUDED

#include "xobserver.h"

namespace xobserver {

class Update
{
public:
    virtual ~Update() {}
    virtual void receive(Notifier::concrete_notifier_type* source, int x);
};

class Source : public Notifier<Update>
{
public:
    virtual ~Source() {}
    void send(int x);
};

class Sink : public Listener<Update>
{
public:
    virtual ~Sink() {}
    virtual void receive(Notifier::concrete_notifier_type* source, int x);
};

}


#endif
