#ifndef XOBSERVER_H_INCLUDED_
#define XOBSERVER_H_INCLUDED_

#include <iostream>
#include <string>
#include <set>
#include <functional>
#include <memory>

namespace xobserver {

template <typename interface_type> class Listener;

template <typename interface_type>
class Notifier
{
public:
    typedef Listener<interface_type> listener_type;
    typedef typename interface_type::notifier_type concrete_notifier_type;
    ~Notifier() {}

    Notifier(const Notifier& rhs) = delete;
    Notifier& operator= (const Notifier& rhs) = delete;

    bool connect(listener_type* listener);
    bool disconnect(listener_type* listener);
    void disconnectAll();
    size_t num_connected() const;

protected:
    template <typename func_type>
    void notify(func_type func);

    template <typename func_type, typename p1_type>
    void notify(func_type func, const p1_type& p1);

    template <typename func_type, typename p1_type, typename p2_type>
    void notify(func_type func, const p1_type& p1, const p2_type& p2);

private:
    std::set<listener_type> m_listeners;
};

//
// implementation
//

template <typename interface_type>
bool Notifier<interface_type>::connect(listener_type* listener)
{
    if (m_listeners.find(listener) == m_listeners.end()) {
        m_listeners.insert(listener);
        return true;
    }
    return false;
}

template <typename interface_type>
bool Notifier<interface_type>::disconnect(listener_type* listener)
{
    return m_listeners.erase(listener) != 0;
}

template <typename interface_type>
void Notifier<interface_type>::disconnectAll()
{
    using namespace std::placeholders;
    std::for_each(m_listeners.begin(), m_listeners.end(),
            std::bind(&Notifier<interface_type>::disconnect, this, _1)
            );
}

template <typename interface_type>
size_t Notifier<interface_type>::num_connected() const
{
    return m_listeners.size();
}

template <typename interface_type>
template <typename func_type>
void Notifier<interface_type>::notify(func_type func)
{
    using namespace std::placeholders;
    std::for_each(m_listeners.begin(), m_listeners.end(),
        std::bind(func, _1, static_cast<concrete_notifier_type*>(this))
        );
}

template <typename interface_type>
template <typename func_type, typename p1_type>
void Notifier<interface_type>::notify(func_type func, const p1_type& p1)
{
    using namespace std::placeholders;
    std::for_each(m_listeners.begin(), m_listeners.end(),
        std::bind(func, _1, static_cast<concrete_notifier_type*>(this)),
        p1
        );
}

template <typename interface_type>
template <typename func_type, typename p1_type, typename p2_type>
void Notifier<interface_type>::notify(func_type func, const p1_type& p1, const p2_type& p2)
{
    using namespace std::placeholders;
    std::for_each(m_listeners.begin(), m_listeners.end(),
        std::bind(func, _1, static_cast<concrete_notifier_type*>(this)),
        p1,
        p2
        );
}


template <typename interface_type>
class Listener : public interface_type
{
public:
    typedef Notifier<interface_type> notifier_type;
    typedef typename interface_type::notifier_type concrete_notifier_type;

    virtual ~Listener() {}
};


//template <typename subject_type>
//class Of_
//{
//public:
//    typedef subject_type notifier_type;
//};


}

#endif
